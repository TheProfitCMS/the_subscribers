class SubscribeMailer < ActionMailer::Base
  default from: "robot@artelectronics.ru"

  def subscribe_request(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: 'Подписка :: ArtElectronics')
  end

  def unsubscribe_request(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: 'Остановка подписки :: ArtElectronics')
  end
end
