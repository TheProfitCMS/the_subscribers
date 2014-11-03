module TheSubscribers
  module Mailer
    extend ActiveSupport::Concern

    included do
      default from: TheSubscribers.config.from_email
    end

    def subscribe_request(subscriber)
      @subscriber = subscriber
      mail(to: @subscriber.email, subject: I18n.t('subscribers.confirm_email'))
    end

    def unsubscribe_request(subscriber)
      @subscriber = subscriber
      mail(to: @subscriber.email, subject: I18n.t('subscribers.stop_email'))
    end
  end
end
