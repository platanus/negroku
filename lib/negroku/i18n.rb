require 'i18n'
require 'set'

en = {
  capified:                    'Capified',
  written_file:                'create %{file}',
  application_name:            'Give your application a name',
  other:                       'Other',
  choose_repo_url:             'Choose the repository url',
  type_repo_url:               'Type the url and username e.g. git@github.com:username/app-name.git',
  choose_stages:               'Select the stages you are going to use'
}

I18n.backend.store_translations(:en, { negroku: en })

if I18n.respond_to?(:enforce_available_locales=)
  I18n.enforce_available_locales = true
end
