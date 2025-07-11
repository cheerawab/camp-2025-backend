FROM python:3.13-alpine AS production

WORKDIR /code

RUN apk add --no-cache \
  build-base \
  gcc \
  g++ \
  musl-dev \
  linux-headers

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy dependency files first
COPY pyproject.toml uv.lock /code/

# Install dependencies using uv from lockfile
RUN uv venv && uv pip sync uv.lock

# Copy source code
COPY main.py /code/

EXPOSE 8080

CMD ["uv", "run", "fastapi", "run", "main.py", "--host", "0.0.0.0", "--port", "8080"]
