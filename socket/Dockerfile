# Use Node.js 18 alpine image to create 
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json or yarn.lock if applicable
COPY package*.json ./

# Install the necessary dependencies
RUN npm install

# Copy the rest of the application code
COPY ./ ./

# Expose the port your socket server will run on (adjust if needed)
EXPOSE 4000

# Start the socket server
CMD ["npm", "start"]
