# Monster Trivia

This is a simple application that uses Rails 7, Hotwire, and the [OpenTDB](https://opentdb.com) to build a multiplayer trivia game for up to four players. It's still in active development so it doesn't do that quite yet. Maybe it will grow up someday. It's also not particularly monster themed yet, but I was initially thinking to have the players have some monster tropes and maybe some monster mechanics. That's even further down the road, though.

## Requirements

### Native

* Ruby 3.1.2
* Bundler
* Foreman (installed outside of the project, globally please)
* Postgres
* Redis

### Docker Compose

* Make sure you have docker installed on your system

## Installation

* Clone from github

###  Native

* Copy `dotenv` to `.env`
* Edit `.env` as necessary to point it at your local development servers
* Run `bin/setup`
* Once everything has been installed, use `bin/dev` to run the tailwind build process, the sidekiq job queue, and the rails server in three different processes.
  * Alternatively, you can run these commands directly with `bin/rails s`, `bin/rails tailwindcss:watch`, and `bin/sidekiq` in three separate terminal instances
* In development, run `bin/guard` to detect changes to files and run relevant specs. This will help assure that nothing is breaking.

### Docker Compose

* Run `bin/docker-setup` to build the images, set up the database, and start the services
* For future runs you can use `bin/docker-dev` to start the services and attach to view the logs
  * Optionally run `docker compose exec web bin/guard` to start the rspec watcher.
  
### Hybridized

This approach runs the database servers in docker, but the application servers locally

* Run `bin/db-restart`
* Copy `.dotenv` to `.env`
* Run `bin/setup`
* Run `bin/dev` to start the local suite of servers

Use `docker compose exec web bin/rails spec` to run specs

To install new dependencies, rebuild the web image with `docker compose build web`

⚠️: When using `docker compose run`, you will accumulate stopped containers over time. Consider using the `--rm` flag to automatically clean up after yourself. For example, `docker compose run --rm guard`.
