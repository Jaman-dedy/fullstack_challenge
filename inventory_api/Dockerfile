FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY . .

RUN mix compile

CMD ["mix", "phx.server"]