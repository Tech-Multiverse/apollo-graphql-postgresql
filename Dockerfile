# Use the Node.js 18-alpine base image
FROM node:18-alpine

# Install PostgreSQL client tools to get pg_isready
RUN apk add --no-cache postgresql-client

# Set the working directory inside the container
WORKDIR /app

# Copy the entire project into the container's working directory
COPY . .

# Give execution permission to the init-db.sh script
RUN chmod +x ./init-db.sh

# Install dependencies and start the Apollo Server
CMD ["sh", "-c", "./init-db.sh"]
