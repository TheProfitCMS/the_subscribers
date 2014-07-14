module TheSubscribers
  module SubscriberVisitsCtrl
    extend ActiveSupport::Concern

    def index
      @subscriber_visits = SubscriberVisit.recent(:created_at).simple_sort(params).pagination(params)
    end
  end
end

