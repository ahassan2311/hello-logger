# Use lightweight Nginx image based on Alpine Linux
FROM nginx:alpine

# Copy all HTML files to Nginx default web root
COPY *.html /usr/share/nginx/html/

# Expose port 80 for HTTP traffic
EXPOSE 80

# Run Nginx in the foreground (not as a daemon)
CMD ["nginx", "-g", "daemon off;"]
