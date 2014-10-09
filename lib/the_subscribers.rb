_root_ = File.expand_path('../../',  __FILE__)
require "the_subscribers/version"
require "the_subscribers/config"

require 'the_notification'
require 'the_simple_sort'
require 'the_pagination'

require 'state_machine'
require 'haml'

module TheSubscribers
  class Engine < Rails::Engine; end
end

# Loading of concerns
require "#{_root_}/config/routes.rb"

%w[ controller subscriber_visits_controller ].each do |concern|
  require "#{_root_}/app/controllers/concerns/#{concern}.rb"
end

%w[ model subscriber_visit ].each do |concern|
  require "#{_root_}/app/models/concerns/#{concern}.rb"
end
