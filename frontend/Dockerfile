# Use the Node.js 18 Alpine image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and yarn.lock to the working directory
COPY package.json yarn.lock ./

# Install dependencies using Yarn
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY public/ ./public
COPY src/ ./src
COPY *.js ./

# Build the application
RUN npm run  build

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]

