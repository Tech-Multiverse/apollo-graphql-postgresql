#!/bin/sh

echo "Waiting for Postgres to be ready..."

# Wait until Postgres is ready
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER"; do
  sleep 1
done

# Adding a brief sleep to ensure Postgres is fully ready
sleep 2

echo "Postgres is ready, creating users table..."

# Set the PGPASSWORD environment variable to avoid prompting for a password
export PGPASSWORD=$POSTGRES_PASSWORD

# Run the SQL command to create the users table
psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);"

if [ $? -eq 0 ]; then
  echo "Users table created successfully."
else
  echo "Failed to create users table." >&2
  exit 1
fi

echo "Installing Node.js dependencies..."

# Install Node.js dependencies
npm install

if [ $? -eq 0 ]; then
  echo "Dependencies installed successfully."
else
  echo "Failed to install dependencies." >&2
  exit 1
fi

echo "Starting Apollo Server..."

# Start the Apollo Server
node index.js
