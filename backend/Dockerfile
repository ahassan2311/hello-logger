# Use lightweight Node.js Alpine Image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all backend source files to container
COPY . .

# Expose the port your backend listens on
EXPOSE 4000

# Start the backend service
CMD ["npm", "start"]
