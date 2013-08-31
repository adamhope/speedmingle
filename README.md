speedmingle
===========

#### CircleCI: http://circleci.com/gh/dbousamra/speedmingle

#### Heroku deployment: http://speedmingle.herokuapp.com/

### Running the app:

1. Pull dependencies down

  ```shell
  → bundle install
  ...
  Your bundle is complete!
  ```
2. Start MongoDB server

  ```shell
  → mongod
  all output going to: /usr/local/var/log/mongodb/mongo.log
  ```
3. Run the app

  ```shell
  → rackup
  [2013-08-28 07:38:42] INFO  WEBrick 1.3.1
  [2013-08-28 07:38:42] INFO  ruby 1.9.3 (2012-04-20) [x86_64-darwin12.2.0]
  [2013-08-28 07:38:42] INFO  WEBrick::HTTPServer#start: pid=15798 port=9292
  ```

### Running the specs: 

```shell
→ rspec
Finished in 0.32593 seconds
20 examples, 0 failures
```

### Rake tasks:

##### rake db:drop
Will drop all collections from db

##### rake db:seed
Seeds the database with 12 dummy participants

### CI and Deploying the app:

Pushing to Github (`origin/master` remote) will automatically fire off specs via [CircleCI:](https://circleci.com/gh/dbousamra/speedmingle) and also deploy to [Heroku](http://speedmingle.herokuapp.com/). 

PLEASE. PLEASE do not force push onto Heroku remote(`heroku/master`). It will cause CircleCI to have a shit-fit.
