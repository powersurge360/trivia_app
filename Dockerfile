FROM ruby:3.0.3
WORKDIR /app
RUN apt-get update
RUN apt-get install -y libpq-dev
COPY Gemfile Gemfile.lock /app
RUN bundle install
COPY . /app
RUN RAILS_ENV=production bin/rails assets:precompile

ENTRYPOINT ["./entry-point.sh"]

CMD ./bin/rails s
