# Python UV Docker Image Copilot Instructions

## Project Overview

This is a Docker image project that provides a specialized container for running Python applications with UV package manager. The image extends the official `ghcr.io/astral-sh/uv` base image and automates dependency installation from `pyproject.toml` files.

## Architecture & Key Components

### Core Files

- `Dockerfile`: Multi-stage build using UV base image with Python 3.12-slim
- `docker-entrypoint.sh`: Startup script that detects `pyproject.toml` and runs `uv pip install --system -e .`
- `example/`: Working reference implementation demonstrating proper project structure

### Critical Workflow Patterns

**Container Startup Flow:**

1. Entrypoint checks for `/app/pyproject.toml`
2. If found, runs `uv pip install --system -e .` from `/app` directory
3. Automatically detects main file location:
   - First checks for `/app/main.py`
   - If not found, checks for `/app/src/main.py`
4. Executes the detected main file

**Expected Project Structure:**

```
your-project/
├── app/
│   ├── main.py          # Option 1: Main file directly in /app
│   ├── src/
│   │   └── main.py      # Option 2: Main file in /app/src
│   └── pyproject.toml   # UV-compatible project file
└── docker-compose.yml   # Volume mounts ./app:/app
```

## Development Workflows

### Local Testing

Use the example directory as a test case:

```bash
cd example && docker-compose up --build
```

### CI/CD Integration

- `docker-publish.yml`: Triggered by repository dispatch or manual workflow
- `daily-update-check.yml`: Monitors upstream releases and auto-builds new versions
- Build includes automated testing with curl health checks on port 8080

### Version Management

- Versions are tracked against upstream releases
- `latest-version.txt` file tracks current built version (created by CI)
- Automatic builds triggered when new versions are detected

## Project-Specific Conventions

### UV Integration

- Always use `--system` flag with `uv pip install` to avoid virtual environment conflicts
- Dependencies must be declared in `pyproject.toml`, not `requirements.txt`
- The container expects UV project structure, not traditional pip workflows

### Application Configuration

- For web applications, ensure they bind to `host='0.0.0.0', port=8080` for container networking
- `PYTHONUNBUFFERED=1` is required for proper logging in containers

### Docker Best Practices

- Multi-stage build reduces final image size
- Build tools are only in builder stage, not runtime
- Volume mount pattern: `./app:/app` for development

## Key Integration Points

- **Base Image**: `ghcr.io/astral-sh/uv:python3.12-bookworm-slim` - provides UV pre-installed
- **Registry**: GitHub Container Registry (`ghcr.io`) for image publishing
- **Upstream Monitoring**: Automated tracking of upstream releases via GitHub API
- **Port Exposure**: Standard port 8080 for web applications

## Common Pitfalls

- Entrypoint script path discrepancy: Uses `/resources/docker-entrypoint.sh` in CMD but copies to `/docker-entrypoint.sh`
- Missing `pyproject.toml` will skip dependency installation silently
- No `main.py` found in `/app` or `/app/src` will cause container to exit with error
- Applications not binding to `0.0.0.0` will not be accessible from outside container
- UV commands must use `--system` flag in container context
