FROM python:3.13-alpine AS production

WORKDIR /code

RUN apk add --no-cache \
  build-base \
  gcc \
  g++ \
  musl-dev \
  linux-headers

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy all source files first
COPY . /code/

# Install dependencies using uv
RUN uv sync --frozen --no-cache

EXPOSE 8080

CMD ["uv", "run", "fastapi", "run", "main.py", "--host", "0.0.0.0", "--port", "8080"]
