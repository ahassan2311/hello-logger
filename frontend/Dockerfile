# Stage 1: Build React app
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all frontend source files
COPY . .

# Build React app for production
RUN npm run build

# Stage 2: Serve build with nginx
FROM nginx:alpine

# Copy built static files from build stage to nginx default folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start nginx server in foreground
CMD ["nginx", "-g", "daemon off;"]
