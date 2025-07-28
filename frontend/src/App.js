import React, { useState } from 'react';

function App() {
  const [message, setMessage] = useState('');
  const [response, setResponse] = useState('');

  const sendLog = async () => {
    try {
      const res = await fetch('/api/log', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message }),
      });
      const data = await res.json();
      setResponse(data.status || 'Success!');
    } catch (err) {
      setResponse('Error sending log');
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial' }}>
      <h1>Hello Logger Frontend</h1>
      <input
        type="text"
        placeholder="Enter log message"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        style={{ width: '300px', padding: '8px' }}
      />
      <button onClick={sendLog} style={{ marginLeft: '10px', padding: '8px 12px' }}>
        Send Log
      </button>
      <div style={{ marginTop: '20px' }}>
        <strong>Response:</strong> {response}
      </div>
    </div>
  );
}

export default App;
