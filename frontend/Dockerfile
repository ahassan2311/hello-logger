FROM nginx:alpine

# Copy static file to default nginx root
COPY index.html /usr/share/nginx/html/index.html

# Optional: Customize nginx default config (skip if not needed)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
