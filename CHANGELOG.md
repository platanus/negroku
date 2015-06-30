# Negroku 2.x Changelog

Reverse Chronological Order:

## Unreleased

https://github.com/platanus/negroku/compare/v2.5.3...HEAD

## `2.5.3`

https://github.com/platanus/negroku/compare/v2.5.2...v2.5.3

FEATURE:
- On whenever you now can change the log and template values.

FIX:
- Whenever was always being enabled because it's a negroku dependency, now we check for the `config/schedule.rb` file
- Whenever now honors the rails environment

## `2.5.2`

https://github.com/platanus/negroku/compare/v2.5.1...v2.5.2

FIX:
- Remote rails console.
- Delayed job detection from gemfile
- Gem detection now use locked specs to detect subdependencies

## `2.5.1`

https://github.com/platanus/negroku/compare/v2.5.0...v2.5.1

FEATURE:
- Runs `bundle binstubs negroku capistrano` on app creation.

## `2.5.0`

https://github.com/platanus/negroku/compare/v2.4.2...v2.5.0

FEATURES:
- Capfile requires are inferred from the project and asked on the cli ui
- Adds update command `negroku app update` to update the Capfile with the latest features
- Adds gem version checking from rubygems
- Adds Capfile version checking based on current gem version

FIX:
- nginx default value for ssl certificate key

BREAKING CHANGES:
- Multiple requires from the Capfile changed, so yo need to update the capfile using the `negroku app update` command

## `2.4.2`

https://github.com/platanus/negroku/compare/v2.4.1...v2.4.2

FIX:
- sphinx failed on first time deploys
- change eye default timeouts for delayed jobs and process template

## `2.4.1`

https://github.com/platanus/negroku/compare/v2.4.0...v2.4.1

FIX:
- Fix unicorn restart bug, thanks to @nicolasmery and @amosrivera 

## `2.4.0`

https://github.com/platanus/negroku/compare/v2.3.5...v2.4.0

FEATURE
- Unicorn: adds a way to change cpu and memory eye check for unicorn    

FIXES
- Rbenv: 
  - `rbenv:vars:show` will work even before the firts deploy, close #96
  - Bulk environmental variables on stage creation, close #99

BREAKING CHANGES
- By default negroku will load capistrano task  with the `.rake` extension intead of `.cap` This will change only if you udpdate the `Capfile`

## `2.3.5`

https://github.com/platanus/negroku/compare/v2.3.1...v2.3.5

- improve sphinx support. Now it rebuild the index whenever the configuration changed
- updates capistrano-nodenv. Now it logs successful instead of fail when the correct node version is found
- logs cab be terminated gracefully with ctrl+c

## `2.3.1`

https://github.com/platanus/negroku/compare/v2.3.0...v2.3.1

- eye roles not being set (capistrano 3.4.0 now really honor the roles)

## `2.3.0`

https://github.com/platanus/negroku/compare/v2.2.0...v2.3.0

- disable delayed-jobs and whenever by default on the capfile template
- adds support for sphinx and thinkinx sphinx processes and tasks
- update capistrano dependency to `3.4.0`
- adds github deployment api support

## `2.2.0`

https://github.com/platanus/negroku/compare/v2.1.0...v2.2.0

FIXES:
- fixed delayed job require on capfile

BREAKING CHANGES:
- change default location of rbenv. Now the default are global installation on `/urs/local/rbenv`
- change default location of nodenv. Now the default are global installation on `/urs/local/nodenv`
- eye action are forced to the global ruby version instead of the project ruby version

## `2.1.0`

- Application is reloaded when environment change

BRAKING CHANGES:
- `rbnev:vars` tasks `add` and `remove` where changed to `set` and `unset`
