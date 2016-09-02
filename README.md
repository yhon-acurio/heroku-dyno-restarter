[![Dependency Status](https://gemnasium.com/badges/github.com/artemv/heroku-dyno-restarter.svg)](https://gemnasium.com/github.com/artemv/heroku-dyno-restarter)

## What is it
A simple microservice app that can restart dynos of given Heroku application. Expected usage is this:

* set up a webhook for target application via Heroku logging plugin like Papertrail.
* This webhook should be run when the target app notices that sidekiq has stuck, and request
`https://my-heroku-dyno-restarter.herokuapp.com/api/restart_workers?key=restart-webhook-key&kind=web`
to restart it. 'kind' parameter here must match the process kind key at target app's Procfile, default is 'worker'.

This is implemented as a separate service to be alive when the target app feels bad and e.g. its Sidekiq queue stucks
for some reason.

## Target app access key
This app needs Heroku OAuth key to be able to restart target app, this is set via RESTART_API_KEY env var.
To obtain the OAuth key do this:

* set up a Heroku user account that basically has access only to target application - this env key will be visible to
everyone who has to the restarter app and you might not want to give them ability to restart other apps.
* get the OAuth key of that user via that user's "Account settings" page at Heroku
* put that key to RESTART_API_KEY env var of the restarter app

See also .env.example for other configuration keys.

## Local installation

* Clone the master repo: `git clone https://github.com/artemv/heroku-dyno-restarter.git && cd heroku-dyno-restarter`
* Copy .env.example file to .env and change values as appropriate for your local env
* Install Ruby 2.3.1 from https://www.ruby-lang.org/en/downloads/ or via RVM (https://rvm.io/)
* Install Bundler and dependencies:
```
gem install bundler
bundle install
```
* run local webserver:
```
rails s
```

## Deployment
```
git remote add heroku https://git.heroku.com/my-heroku-dyno-restarter.git
git push heroku
```

## Credits

© Artem Vasiliev 2016

Based on [this blog post](https://www.stormconsultancy.co.uk/blog/development/ruby-on-rails/automatically-restart-struggling-heroku-dynos-using-logentries/).

Initially developed for the [Socket](https://viasocket.com) project of [Walkover](https://www.walkover.in) team, they rock!
