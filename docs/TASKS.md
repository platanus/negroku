# Tasks

* [Eye](#eye)
* [Rails](#rails)
    * [Remote Console](#remote-console)
* [Whenever](#whenever)
    * [Config](#config)
* [Logs](#logs)

### Eye

Negroku support process monitoring via the [Eye gem](https://github.com/kostya/eye). Currently adds monitoring to

- unicorn
- puma
- thinking_sphinx
- delayed_job

Each monitor can be further customized using variables.

```ruby
set: eye_<process>_<setting>, <value>
```

The main setting that can be customized are timeouts and grace times.

```ruby
# delayed job timeouts
set: eye_delayed_job_start_timeout, 20.seconds
set: eye_delayed_job_stop_timeout, 1.minute
set: eye_delayed_job_restart_timeout, 1.minute

# For puma
set: eye_puma_start_grace, 45.seconds
set: eye_puma_stop_grace, 30.seconds
set: eye_puma_restart_grace, 2.minutes
```

#### Monitor custom processes

If you have other processes in your applicacion you can monitor them
using the `watch_process` method in your `deploy.rb` file

You'll need to setup the **start_command**, **stop_command** and **pid location**.

```ruby
watch_process(:other_process, template: :process,
                              start_command: "process start",
                              stop_command: "process stop",
                              start_timeout: 50.seconds,
                              restart_grace: 1.minutes,
                              pid_file: "path/to/pid"
             )
```

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

### Logs

You can stream al the application logs from the server.

```shell
# to get all application logs
cap production logs

# to get all nginx logs
cap production logs:nginx

# to get the nginx access or error logs only
cap production logs:nginx:access
cap production logs:nginx:error
```

You can pass an argument with the number of line to show in the beginning

```shell
# to get the nginx access logs starting with 1000 lines
cap production logs:nginx:access[1000]
```

The build in supported log tasks are


- `logs:nginx:access`
- `logs:nginx:error`
- `logs:delayed_job:out`
- `logs:eye:app`
- `logs:puma:error`
- `logs:puma:access`
- `logs:rails:app`
- `logs:sphinx:out`
- `logs:sphinx:query`
- `logs:unicorn:error`
- `logs:unicorn:out`
- `logs:whenever:out`

> The will be loaded based on what module you loaded in your `Capfile`

#### Custom Logs

If you have other logs in your applicacion you can add them to the log task
using the `define_logs` method in your `deploy.rb` file

This assume that your logs are in the `shared/logs` folder

```ruby
define_logs(:other_process, {
  error: 'other_process_error.log',
  out: 'other_process_out.log'
})
```

With that you will have a new `other_process` task

- `logs:other_process:error`
- `logs:other_process:out`
