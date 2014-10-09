module TheSubscribers
  def self.configure(&block)
    yield @config ||= TheSubscribers::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :from_email
  end

  configure do |config|
    config.from_email = 'mailbox@example.com'
  end
end
