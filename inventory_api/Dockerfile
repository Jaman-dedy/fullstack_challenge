FROM elixir:1.12.0-alpine

RUN apk add --no-cache build-base postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY . .

RUN mix compile

CMD ["mix", "phx.server"]