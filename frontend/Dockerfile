FROM nginx:alpine
# Copy the HTML file directly to nginx
COPY *.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]