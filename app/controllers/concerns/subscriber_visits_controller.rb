module TheSubscribers
  module SubscriberVisitsCtrl
    extend ActiveSupport::Concern

    def index
      @subscriber_visits = SubscriberVisit.recent.pagination(params)
    end
  end
end

