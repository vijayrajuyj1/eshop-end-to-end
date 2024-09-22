# Use Node.js 18 alpine image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json or yarn.lock
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY ./ ./

# Expose the port the backend service runs on (adjust if needed)
EXPOSE 8000

# Start the application
CMD ["npm","run", "dev"]
