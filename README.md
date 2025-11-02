# NiceGUI-UV-Dockerimage

A Docker image for your NiceGUI UV projects, based on the official NiceGUI Docker setup but adapted for UV package manager.

## Overview

This Docker image is designed to run NiceGUI applications managed with UV (a fast Python package installer). Unlike the official NiceGUI images that expect a `main.py` at the root, this image expects a UV project structure with a `pyproject.toml` file.

The image is based on the official UV Docker image (`ghcr.io/astral-sh/uv`) which includes UV pre-installed.

## Features

- Based on Python 3.12-slim for minimal image size
- Uses UV package manager for fast dependency installation
- Automatically installs dependencies from `pyproject.toml` on startup
- Compatible with standard UV project structure
- Exposes port 8080 by default

## Usage

### Project Structure

Your project should be organized as follows:

```
your-project/
├── app/
│   ├── main.py
│   └── pyproject.toml
└── docker-compose.yml (optional)
```

### Example `pyproject.toml`

```toml
[project]
name = "your-nicegui-app"
version = "0.1.0"
description = "Your NiceGUI application"
dependencies = [
    "nicegui>=1.4.0",
]
requires-python = ">=3.8"
```

### Example `main.py`

```python
from nicegui import ui

@ui.page('/')
def index():
    ui.label('Hello from NiceGUI!')
    ui.button('Click me!', on_click=lambda: ui.notify('Clicked!'))

ui.run(host='0.0.0.0', port=8080)
```

### Running with Docker

#### Option 1: Using Docker directly

```bash
# Build the image
docker build -t nicegui-uv .

# Run the container
docker run -p 8080:8080 -v $(pwd)/app:/app nicegui-uv
```

#### Option 2: Using Docker Compose

Create a `docker-compose.yml`:

```yaml
services:
  nicegui-app:
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
3. The application starts by running `python main.py`

## Environment Variables

- `PYTHONUNBUFFERED=1` - Ensures Python output is sent straight to terminal without buffering

## Port

The container exposes port 8080 by default, which is the standard port for NiceGUI applications.

## License

MIT License - See LICENSE file for details
