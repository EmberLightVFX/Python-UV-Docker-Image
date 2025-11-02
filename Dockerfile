# Use a Python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Setup a non-root user
RUN groupadd --system --gid 1000 nonroot \
 && useradd --system --gid 1000 --uid 1000 --create-home nonroot

LABEL maintainer="Jacob Danell <jacob@emberlight.se>"

# Install the project into `/app`
WORKDIR /app

# Change ownership of /app to nonroot user
RUN chown -R nonroot:nonroot /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Ensure installed tools can be executed out of the box
ENV UV_TOOL_BIN_DIR=/usr/local/bin

# Copy the entrypoint script
COPY docker-entrypoint.sh /resources/docker-entrypoint.sh
RUN chmod +x /resources/docker-entrypoint.sh

EXPOSE 8080
ENV PYTHONUNBUFFERED=True

ENTRYPOINT ["/resources/docker-entrypoint.sh"]