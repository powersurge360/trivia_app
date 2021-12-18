FROM ruby:3.0.3-bullseye AS base
WORKDIR /app
COPY . /app
RUN apt-get update
RUN apt-get install -y nodejs npm libpq-dev
RUN bundle install
RUN npm install -g yarn
RUN yarn install

ENTRYPOINT ["./entry-point.sh"]

CMD ./bin/rails s -b 0.0.0.0

FROM base AS frontend

CMD yarn build:css --watch
