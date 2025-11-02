#!/bin/bash
set -e

echo "Starting NiceGUI UV Docker Container..."

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

echo "Starting application..."
exec "$@"
