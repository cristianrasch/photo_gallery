# README

Simple photo gallery app that groups photos on a yearly and monthly basis.

### Ruby version

See the .ruby-version file.

### System dependencies

* imagemagick or graphicsmagick

### Configuration

1. Run bundle install
2. cp .env.example .env
3. Edit .env to match your system/preferences

### Services

Let rerun restart your development server:

```bash
$ bundle exec rerun -- rackup
```

* Deployment instructions

Fully automated via [Capistrano](https://capistranorb.com/):

```bash
$ REMOTE_SRV=mysrv.com REMOTE_USR=myusr bundle exec cap production deploy
```
