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
