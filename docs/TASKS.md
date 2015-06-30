# Tasks

* [Rails](#rails)
    * [Remote Console](#remote-console)
* [Whenever](#whenever)
    * [Config](#config)

### Rails 

##### Remote Console

Negroku adds support to remotelly connect to the rails console integrating de [capistrano-rails-console][1] gem. 

```shell
cap <stage> rails:console
cap <stage> rails:console sandbox=1
```

[1]: https://github.com/ydkn/capistrano-rails-console

### Whenever 

**Note:** By default we are not adding any path to the cron execution PATH. It's up the you to add the needed path to the PATH variable in the cron file.

##### Config
You can change some defaults adding this variables to your `deploy.rb`

1. Template
default tempalte is `bash -lc ':job'`

    ```ruby
    set :whenever_template, "bash -lc ':job'" #default
    set :whenever_template, "PATH=./bin:$PATH && bash -lc ':job'" #add location to the path
    ```
