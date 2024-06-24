FROM elixir:1.14

RUN apt-get update && \
  apt-get install -y postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix local.hex --force && mix local.rebar --force

RUN mix deps.get

COPY . .

RUN mix do deps.get, deps.compile

RUN mix compile
RUN MIX_ENV=prod mix compile

ENV MIX_ENV=dev

CMD ["mix", "phx.server"]