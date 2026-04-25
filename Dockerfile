FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

LABEL org.opencontainers.image.title="etf-knapsack"
LABEL org.opencontainers.image.description="Calculate buy order combinations for your ETF Portfolio given a budget."
LABEL org.opencontainers.image.source="https://github.com/vlanx/etf-knapsack"
LABEL org.opencontainers.image.licenses="MIT"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-install-project

FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv

COPY knapsack.py info.toml ./

ENTRYPOINT ["python", "knapsack.py"]
CMD ["--help"]
