# Python UV Docker Image

A Docker image for running Python applications managed with UV package manager, featuring automatic dependency installation and flexible project structures.

## Overview

This Docker image is designed to run Python applications managed with UV (a fast Python package installer). The image automatically detects your project structure and runs your application, whether `main.py` is located directly in `/app` or under `/app/src`.

The image is based on the official UV Docker image (`ghcr.io/astral-sh/uv`) which includes UV pre-installed.

## Features

- Based on Python 3.12-slim for minimal image size
- Uses UV package manager for fast dependency installation
- Automatically installs dependencies from `pyproject.toml` on startup
- Compatible with standard UV project structure
- Flexible project layout detection (supports both `/app/main.py` and `/app/src/main.py`)
- Exposes port 8080 by default (configurable)

## Usage

### Project Structure

Your project can be organized in two ways:

**Option 1: Main file in `/app`**
```text
your-project/
├── app/
│   ├── main.py
│   └── pyproject.toml
└── docker-compose.yml (optional)
```

**Option 2: Main file in `/app/src`**
```text
your-project/
├── app/
│   ├── src/
│   │   └── main.py
│   └── pyproject.toml
└── docker-compose.yml (optional)
```

### Example `pyproject.toml`

```toml
[project]
name = "your-python-app"
version = "0.1.0"
description = "Your Python application"
dependencies = [
    "some-package>=1.0.0",
]
requires-python = ">=3.8"
```

### Example `main.py` (for web applications)

```python
# For NiceGUI applications
from nicegui import ui

@ui.page('/')
def index():
    ui.label('Hello from NiceGUI!')
    ui.button('Click me!', on_click=lambda: ui.notify('Clicked!'))

ui.run(host='0.0.0.0', port=8080)

# For other web frameworks, ensure they bind to 0.0.0.0:8080
```

### Running with Docker

#### Option 1: Using Docker directly

```bash
# Build the image
docker build -t python-uv .

# Run the container
docker run -p 8080:8080 -v $(pwd)/app:/app python-uv
```

#### Option 2: Using Docker Compose

Create a `docker-compose.yml`:

```yaml
services:
  python-app:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./app:/app
    environment:
      - PYTHONUNBUFFERED=1
```

Then run:

```bash
docker-compose up
```

### Testing the Example

An example application is provided in the `example/` directory:

```bash
cd example
docker-compose up --build
```

Then visit `http://localhost:8080` in your browser.

## How It Works

1. On container startup, the entrypoint script checks for `/app/pyproject.toml`
2. If found, UV installs all dependencies specified in the file
3. The script automatically detects your main file:
   - First checks for `/app/main.py`
   - If not found, checks for `/app/src/main.py`
4. Runs the detected main file with Python

## Environment Variables

- `PYTHONUNBUFFERED=1` - Ensures Python output is sent straight to terminal without buffering

## Port

The container exposes port 8080 by default. Make sure your application binds to `host='0.0.0.0'` and `port=8080` for external access.

## License

MIT License - See LICENSE file for details
