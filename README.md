# Monster Trivia

This is a simple application that uses Rails 7, Hotwire, and the [OpenTDB](https://opentdb.com) to build a multiplayer trivia game for up to four players. It's still in active development so it doesn't do that quite yet. Maybe it will grow up someday. It's also not particularly monster themed yet, but I was initially thinking to have the players have some monster tropes and maybe some monster mechanics. That's even further down the road, though.

## Requirements

### Native

* Ruby 3.0.3 (soon to be 3.1.0)
* Bundler
* Foreman (installed outside of the project, globally please)
* Postgres
* Redis

### Docker Compose

* Make sure you have docker installed on your system

## Installation

* Clone from github

###  Native

* In the directory, in a terminal, run `bundle install`
* Run `bin/rails db:migrate` to get your database running
* Once everything has been installed, use `bin/dev` to run the tailwind build process, the sidekiq job queue, and the rails server in three different processes.
  * Alternatively, you can run these commands directly with `bin/rails s`, `bin/rails tailwindcss:watch`, and `bin/sidekiq` in three separate terminal instances
* In development, run `bin/guard` to detect changes to files and run relevant specs. This will help assure that nothing is breaking.

### Docker Compose

* Copy `dotenv` to `.env`
* Make any changes you deem necessary (and certainly before deploying)
* Run `docker compose build web` to build the trivia_app image ahead of time (many utilities and tools depend on it)
* Run `docker compose run rails db:migrate` to run database migrations
* Run `docker compose up` to start the suite
  * Optionally run `docker compose run web bin/guard` to start the rspec watcher.

Use `docker compose run rails spec` to run specs

To install new dependencies, rebuild the web image with `docker compose build web`

⚠️: When using `docker compose run`, you will accumulate stopped containers over time. Consider using the `--rm` flag to automatically clean up after yourself. For example, `docker compose run --rm guard`.
