FROM ruby:3.1.2
WORKDIR /app
RUN apt-get update
RUN apt-get install -y libpq-dev
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app
RUN bin/rails assets:precompile

ENTRYPOINT ["./entry-point.sh"]

CMD ./bin/rails s
