module TheSubscribers
  module SubscriberVisitsCtrl
    extend ActiveSupport::Concern

    def index
      @subscriber_visits = SubscriberVisit.pagination(params)
    end
  end
end

