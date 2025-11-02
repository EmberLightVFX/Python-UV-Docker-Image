#!/bin/bash
set -e

echo "Starting UV Docker Container..."

# Check if pyproject.toml exists
if [ -f "/app/pyproject.toml" ]; then
    echo "Found pyproject.toml, installing dependencies with UV..."
    
    # Change to app directory
    cd /app
    
    # Install dependencies using UV to system Python
    # Use --system flag to install to system Python instead of creating venv
    uv pip install --system -e .
    
    echo "Dependencies installed successfully!"
else
    echo "Warning: pyproject.toml not found in /app directory"
    echo "Skipping dependency installation"
fi

# Handle custom PUID/PGID if set
if [ -n "$PUID" ] && [ -n "$PGID" ]; then
    echo "Setting custom user ID $PUID and group ID $PGID..."
    usermod -u $PUID nonroot 2>/dev/null || true
    groupmod -g $PGID nonroot 2>/dev/null || true
    chown -R $PUID:$PGID /app
fi

echo "Starting application..."
if [ -f "/app/main.py" ]; then
    exec su nonroot -c "python /app/main.py"
elif [ -f "/app/src/main.py" ]; then
    exec su nonroot -c "python /app/src/main.py"
else
    echo "Error: No main.py found in /app or /app/src"
    exit 1
fi
