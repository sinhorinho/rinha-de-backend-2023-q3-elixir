FROM elixir:1.14.2-alpine AS builder

WORKDIR /app

ARG MIX_ENV=prod
ENV MIX_ENV $MIX_ENV

COPY mix.exs mix.exs
COPY mix.lock mix.lock

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix do deps.get

COPY . /app

RUN mix do \
  compile, \
  compile.protocols

RUN MIX_ENV=${MIX_ENV} mix release --overwrite

# Build deployment container
FROM alpine:3.16 AS app

ENV MIX_ENV=prod

RUN apk add --no-cache bash curl libgcc libstdc++ zlib

WORKDIR /application

COPY --from=builder /app/_build/${MIX_ENV}/rel/rinha_backend .

CMD ["sh", "-c", "./bin/rinha_backend start"]