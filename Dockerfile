FROM ruby:3.0.3
WORKDIR /app
COPY . /app
RUN apt-get update
RUN apt-get install -y libpq-dev
RUN bundle install

ENTRYPOINT ["./entry-point.sh"]

CMD ./bin/rails s -b 0.0.0.0
