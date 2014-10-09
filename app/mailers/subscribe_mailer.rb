class SubscribeMailer < ActionMailer::Base
  default from: TheSubscribers.config.from_email

  def subscribe_request(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: I18n.t('subscribers.confirm_email'))
  end

  def unsubscribe_request(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: I18n.t('subscribers.stop_email'))
  end
end
