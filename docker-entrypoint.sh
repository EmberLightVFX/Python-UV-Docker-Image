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

echo "Starting application..."
if [ -f "/app/main.py" ]; then
    exec python /app/main.py
elif [ -f "/app/src/main.py" ]; then
    exec python /app/src/main.py
else
    echo "Error: No main.py found in /app or /app/src"
    exit 1
fi
