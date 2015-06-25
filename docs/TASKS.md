# Tasks

* [Rails](#rails)
    * [Remote Console](#remote-console)

### Rails 

##### Remote Console

Negroku adds support to remotelly connect to the rails console integrating de [capistrano-rails-console][1] gem. 

```shell
cap <stage> rails:console
cap <stage> rails:console sandbox=1
```

[1]: https://github.com/ydkn/capistrano-rails-console
