FROM elixir:1.14.2-alpine AS builder

WORKDIR /app

ARG MIX_ENV=prod
ENV MIX_ENV $MIX_ENV

COPY mix.exs mix.exs
COPY mix.lock mix.lock

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix do deps.get, compile

COPY . /app

RUN mix deps.clean mime --build

RUN mix do \
  compile, \
  compile.protocols

RUN MIX_ENV=${MIX_ENV} mix release --overwrite

# Build deployment container
FROM alpine:3.16 AS app

# Timezone
RUN apk add -U tzdata
ENV TZ=America/Sao_Paulo
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

ENV MIX_ENV=prod

RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /tmp/aws-env
RUN chmod +x /tmp/aws-env

RUN apk add --no-cache bash curl libgcc libstdc++ zlib

WORKDIR /application

COPY --from=builder /app/_build/${MIX_ENV}/rel/rinha_backend .

CMD ["sh", "-c", "eval $(/tmp/aws-env) && ./bin/rinha_backend start"]