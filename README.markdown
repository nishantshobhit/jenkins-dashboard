# Jenkins Dashboard

[![Build Status](https://travis-ci.org/ustwo/jenkins-dashboard.png?branch=master)](https://travis-ci.org/ustwo/jenkins-dashboard)

A Ruby powered Jenkins dashboard, Jenkins dashboard summarises job and build data into an easy to digest dashboard optimized for large displays. 

![Screenshot](https://github.com/ustwo/jenkins-dashboard/blob/master/doc/screenshot1.png?raw=true)
![Screenshot](https://github.com/ustwo/jenkins-dashboard/blob/master/doc/screenshot2.png?raw=true)

### Dependencies 

* [Ruby](http://www.ruby-lang.org/en/)
* [PostgreSQL](http://www.postgresql.org/)
* [rbenv](https://github.com/sstephenson/rbenv) (recommended)
* [git plugin fork](https://github.com/alexefish/git-plugin)

### Gems

See the the Gemfile for a full list of gems. 

### Configuration

Jenkins Dashboard requires some simple configuration to communicate with your Jenkins installation. 

The [jenkins.yml](https://github.com/ustwo/jenkins-dashboard/blob/master/config/jenkins.yml) file requires a key, client id and URL for to access your Jenkins installation API.

    defaults: &defaults
      client_key: your_client_key
      client_id: your_client_id
      client_url: your_client_url

#### Jenkins Configuration

If you wish to display git stats for your jobs and builds you will need to install [this fork](https://github.com/alexefish/git-plugin) of the Jenkins Git Plugin. The plugin will expose git stats to the Jenkins Dashboard not available with the default Jenkins Plugin.

You will also need to create a Jenkins View named `WallDisplay`, all jobs added to this view will be available to the Jenkins Dashboard, this can be done at the `/newView` path of your Jenkins installation.

### Usage

Ensure you have a postgreSQL installation running then run the following commands to create the database and schema:

    $ rake db:create:all
    $ rake db:migrate

You can then start the application. 

#### Fetching jobs

Jenkins Dashboard implements the [whenever](https://github.com/javan/whenever) gem to fetch jobs via a cron job, see schedule.rb for configuration. 

    every 1.minutes do
      runner "US2::Jenkins.instance.sync", :environment => :production
    end

You will need to write to your system/servers crontab to start the cron job using the command: `whenever -w`. For capistrano instructions see the [whenever](https://github.com/javan/whenever) readme. 

#### Populating the database

There is a rake task available which will traverse through your Jenkins history and populate the database with all jobs. 

    rake populate

See issue #1.

#### Running tests

To run tests locally simply execute the `guard` command. 

### Documentation

TBC

### Team

* Developers: [Alex Fish](https://github.com/alexefish), [Nuno Coelho Santos](https://github.com/nunosans)
* Design:  [Nuno Coelho Santos](https://github.com/nunosans)
* 

### License 

    The MIT License (MIT)
    
    Copyright (c) 2013 ustwo
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
