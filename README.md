# Monster Trivia

This is a simple application that uses Rails 7, Hotwire, and the [OpenTDB](https://opentdb.com) to build a multiplayer trivia game for up to four players. It's still in active development so it doesn't do that quite yet. Maybe it will grow up someday. It's also not particularly monster themed yet, but I was initially thinking to have the players have some monster tropes and maybe some monster mechanics. That's even further down the road, though.

## Requirements

* Ruby 3.0.3 (soon to be 3.1.0)
* Bundler
* Foreman (installed outside of the project, globally please)
* Postgres
* Redis

## Installation

* Clone from github
* In the directory, in a terminal, run `bundle install`
* Once everything has been installed, use `bin/dev` to run the tailwind build process, the sidekiq job queue, and the rails server in three different processes.
  * Alternatively, you can run these commands directly with `bin/rails s`, `bin/rails tailwindcss:watch`, and `bin/sidekiq` in three separate terminal instances
* In development, run `bin/guard` to detect changes to files and run relevant specs. This will help assure that nothing is breaking.
