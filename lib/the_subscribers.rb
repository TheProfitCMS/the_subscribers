_root_ = File.expand_path('../../',  __FILE__)
require "the_subscribers/version"

require 'state_machine'
require 'encryptor'
require 'haml'

module TheSubscribers
  class Engine < Rails::Engine; end
end

# Loading of concerns
require "#{_root_}/config/routes.rb"
require "#{_root_}/app/controllers/concerns/controller.rb"

%w[ model states crypt ].each do |concern|
  require "#{_root_}/app/models/concerns/#{concern}.rb"
end
