## Jenkins Dashboard

### Getting Started

* install [RVM](https://rvm.io/)
* `cd` to the project directory
* `bundle`

### Populating your local database

There is a rake task available which will populate the database with all job data for each job shown on the 'Wall Display' view inside Jenkins. To run the rake task call

`rake populate`

This may take some time depending on the amount of jobs displayed on on the 'Wall Display' view.

### Deployment

Jenkins will automatically deploy any commits to the master branch

### TODO

* Jasmine Tests
* Switch to Mongodb
* Refactor Javascript graph code to Coffee
