#What is it
A simple microservice app that can restart Sidekiq workers of given Heroku application. Expected usage is this:

* set up a webhook for target application via Heroku logging plugin like Papertrail.
* This webhook should be run when the target app notices that sidekiq has stuck, and request
`https://viasocket-restarter.herokuapp.com/api/restart_workers?key=restart-webhook-key`
to restart it.

This is implemented as a separate service to be alive when the target app's Sidekiq stucks.

#Target app access key
This app needs Heroku OAuth key to be able to restart target app, this is set via RESTART_API_KEY env var.
To obtain the OAuth key do this:

* set up a Heroku user account that basically has access only to target application - this env key will be visible to
everyone who has to the restarter app and you might not want to give them ability to restart other apps.
* get the OAuth key of that user here: http://screencast.com/t/BvItlkzmdM
* put that key to RESTART_API_KEY env var of the restarter app

See also .env.example for other configuration keys.

#Local installation
* Create a dir for viasocket development instances:
```
cd ~ # or your preferred path for projects here
mkdir -p viasocket/viasocket-restarter && cd viasocket
```
* Clone the master repo: `git clone git@bitbucket.org:walkover101/viasocket-restarter.git && cd viasocket-restarter`
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

#Deployment
```
git remote add heroku https://git.heroku.com/sockets-io.git
git push heroku
```
