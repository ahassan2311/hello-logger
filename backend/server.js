const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 4000;

// Store logs in memory (note: will reset when container restarts)
let logs = [];

// Parse JSON bodies
app.use(express.json());

// Use cors middleware 
app.use(cors());

// Serve static files from public directory
app.use(express.static('public'));

app.post('/api/log', (req, res) => {
  let message;
  
  // Handle both JSON and text requests
  if (typeof req.body === 'string') {
    message = req.body;
  } else if (req.body && req.body.message) {
    message = req.body.message;
  } else {
    message = 'No message provided';
  }
  
  // Store the log with timestamp
  const logEntry = {
    id: Date.now(),
    message: message,
    timestamp: new Date().toISOString(),
    source: req.headers['user-agent'] || 'Unknown'
  };
  
  logs.unshift(logEntry); // Add to beginning of array
  
  // Keep only last 100 logs to prevent memory issues
  if (logs.length > 100) {
    logs = logs.slice(0, 100);
  }
  
  console.log("📥 Log received:", message);
  res.json({ status: '✅ Message received by backend!' });
});

// API endpoint to get all logs
app.get('/api/logs', (req, res) => {
  res.json(logs);
});

// API endpoint to clear logs
app.delete('/api/logs', (req, res) => {
  logs = [];
  res.json({ status: 'Logs cleared' });
});

app.get("/", (req, res) => {
  res.send("👋 Hello from the backend!");
});

// Logs dashboard endpoint
app.get("/logs", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Logs Dashboard</title>
      <style>
        body { 
          font-family: Arial, sans-serif; 
          max-width: 1200px; 
          margin: 0 auto; 
          padding: 20px;
          background-color: #f5f5f5;
        }
        .header {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          padding: 20px;
          border-radius: 10px;
          margin-bottom: 20px;
          text-align: center;
        }
        .stats {
          display: flex;
          gap: 20px;
          margin-bottom: 20px;
        }
        .stat-card {
          background: white;
          padding: 20px;
          border-radius: 10px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          flex: 1;
          text-align: center;
        }
        .logs-container {
          background: white;
          border-radius: 10px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          overflow: hidden;
        }
        .logs-header {
          background: #2c3e50;
          color: white;
          padding: 15px 20px;
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .log-entry {
          padding: 15px 20px;
          border-bottom: 1px solid #eee;
          display: flex;
          align-items: flex-start;
          gap: 15px;
        }
        .log-entry:last-child { border-bottom: none; }
        .log-entry:nth-child(even) { background-color: #f8f9fa; }
        .log-bullet { 
          color: #27ae60; 
          font-weight: bold; 
          font-size: 18px;
          margin-top: 2px;
        }
        .log-content {
          flex: 1;
        }
        .log-message {
          font-weight: bold;
          margin-bottom: 5px;
          color: #2c3e50;
        }
        .log-meta {
          font-size: 12px;
          color: #7f8c8d;
        }
        .no-logs {
          text-align: center;
          padding: 40px;
          color: #7f8c8d;
          font-style: italic;
        }
        .refresh-btn, .clear-btn {
          background: #3498db;
          color: white;
          border: none;
          padding: 8px 16px;
          border-radius: 5px;
          cursor: pointer;
          margin-left: 10px;
        }
        .clear-btn {
          background: #e74c3c;
        }
        .refresh-btn:hover { background: #2980b9; }
        .clear-btn:hover { background: #c0392b; }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>📊 Logs Dashboard</h1>
        <p>Real-time log monitoring and management</p>
      </div>
      
      <div class="stats">
        <div class="stat-card">
          <h3>📝 Total Logs</h3>
          <p id="total-logs">0</p>
        </div>
        <div class="stat-card">
          <h3>🕒 Last Updated</h3>
          <p id="last-updated">Never</p>
        </div>
        <div class="stat-card">
          <h3>📈 Status</h3>
          <p style="color: #27ae60;">Active</p>
        </div>
      </div>
      
      <div class="logs-container">
        <div class="logs-header">
          <h2>📋 Received Logs</h2>
          <div>
            <button class="refresh-btn" onclick="loadLogs()">🔄 Refresh</button>
            <button class="clear-btn" onclick="clearLogs()">🗑️ Clear All</button>
          </div>
        </div>
        <div id="logs-list">
          <div class="no-logs">No logs received yet...</div>
        </div>
      </div>
      
      <script>
        async function loadLogs() {
          try {
            const response = await fetch('/api/logs');
            const logs = await response.json();
            
            document.getElementById('total-logs').textContent = logs.length;
            document.getElementById('last-updated').textContent = new Date().toLocaleTimeString();
            
            const logsList = document.getElementById('logs-list');
            
            if (logs.length === 0) {
              logsList.innerHTML = '<div class="no-logs">No logs received yet...</div>';
              return;
            }
            
            logsList.innerHTML = logs.map(log => \`
              <div class="log-entry">
                <div class="log-bullet">•</div>
                <div class="log-content">
                  <div class="log-message">\${log.message}</div>
                  <div class="log-meta">
                    🕒 \${new Date(log.timestamp).toLocaleString()} | 
                    🔗 ID: \${log.id}
                  </div>
                </div>
              </div>
            \`).join('');
          } catch (error) {
            console.error('Failed to load logs:', error);
          }
        }
        
        async function clearLogs() {
          if (confirm('Are you sure you want to clear all logs?')) {
            try {
              await fetch('/api/logs', { method: 'DELETE' });
              loadLogs();
            } catch (error) {
              console.error('Failed to clear logs:', error);
            }
          }
        }
        
        // Load logs on page load
        loadLogs();
        
        // Auto-refresh every 5 seconds
        setInterval(loadLogs, 5000);
      </script>
    </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`🚀 Backend running on port ${PORT}`);
  console.log(`📊 Logs dashboard available at: http://localhost:${PORT}/logs`);
});