# Slim Starter Pack: Ruby 'Hello World' API Only Version
[![https://www.slim.ai/](https://img.shields.io/badge/Slim.AI-Starter%20Kit-9cf)](https://www.slim.ai/)
[![https://hub.docker.com/](https://img.shields.io/badge/DockerHub-Image-blue)](https://hub.docker.com/)

Hello Ruby developers! 

Optimize and harden your containerized applications the easy way — with Slim.AI. 

This Starter Kit will help you proactively remove vulnerabilities from your applications. 

Simply replace the application code here with your own application, run it through Slim.AI's [automated container optimization](https://www.slim.ai/docs/optimization) process, and you'll remove up to 90-percent of the image's vulnerabilities while also making it up to 10X smaller. 

No more chasing down hard to patch vulns that your application isn't even using, and you can use any base image you want — even `ruby:latest`. 

# Optimization Results
![Result of optimized Rails image](results.png)

Slimming this Rails container results in 93-percent reduction in overall vulnerabilities. 

## Vulnerability difference by severity 

[See the full report.](https://www.slim.ai/starter-kits/ruby)

# Get Started
To start a Rails application application, you'll need the following libraries installed locally, or running in a dev environment link GitPod, Docker Environments, or Code Spaces. 


``` 
ruby 3.1.2
rails ~> 7.0.3
```

To run locally use:
```
bundle install
RAILS_ENV=development bundle exec rails s -p 3000 -b '0.0.0.0'
```
While using docker:

set ```RAILS_ENV``` as required in Dockerfile.

update ```bin/start``` to switch between puma and rails server.
## Sample Application
Our sample application is a simple REST API that merely returns "Hello World!".

While this app is simple, it's a great starting point for more complex development. 

Project structure
```
├── app
│   ├── channels
│   │   └── application_cable
│   │       ├── channel.rb
│   │       └── connection.rb
│   ├── controllers
│   │   ├── application_controller.rb
│   │   ├── concerns
│   │   └── hello_controller.rb
│   ├── jobs
│   │   └── application_job.rb
│   ├── mailers
│   │   └── application_mailer.rb
│   ├── models
│   │   ├── application_record.rb
│   │   └── concerns
│   └── views
│       └── layouts
│           ├── mailer.html.erb
│           └── mailer.text.erb
├── bin
│   ├── bundle
│   ├── rails
│   ├── rake
│   ├── setup
│   └── start
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── cable.yml
│   ├── credentials.yml.enc
│   ├── database.yml
│   ├── environment.rb
│   ├── environments
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── initializers
│   │   ├── cors.rb
│   │   ├── filter_parameter_logging.rb
│   │   └── inflections.rb
│   ├── locales
│   │   └── en.yml
│   ├── puma.rb
│   ├── routes.rb
│   └── storage.yml
├── config.ru
├── db
│   └── seeds.rb
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── lib
│   └── tasks
├── log
├── public
│   └── robots.txt
├── Rakefile
├── README.md
├── storage
├── test
│   ├── channels
│   │   └── application_cable
│   │       └── connection_test.rb
│   ├── controllers
│   │   └── hello_controller_test.rb
│   ├── fixtures
│   │   └── files
│   ├── integration
│   ├── mailers
│   ├── models
│   └── test_helper.rb
└── vendor
```

Code sample
``` ruby 
class HelloController < ApplicationController
    def index
        yourip = request.remote_ip
        ruby_version = RUBY_VERSION
        rails_version = Rails::VERSION::STRING
        render json: { hello:"world", yourip:yourip,ruby_version:ruby_version,rails_version:rails_version }
      end
end
```

Replace this placholder code with your own application code, and install any necessary dependencies, to create your own slimmable container. 

## Sample Dockerfile
Our Dockerfile builds off of the `rails:latest` image and starts at **979MB**. The slimming process reduces the size by **10X** to just **97MB**. 

![Graph of size reduction](results-size.png)

[See the full report on Slim.AI](https://portal.slim.dev/... )