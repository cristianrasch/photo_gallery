# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
See the .ruby-version file.

* System dependencies
  * imagemagick
  * graphicsmagick

* Configuration

1. Run bundle install
2. cp .env.example .env
3. Edit .env to match your system/preferences

* Services
```bash
$ bundle exec rerun -- rackup
```

* Deployment instructions
```bash
$ bundle exec cap production deploy
```
