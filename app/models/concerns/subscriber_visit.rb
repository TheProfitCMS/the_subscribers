module TheSubscribers
  module SubscriberVisitModel
    extend ActiveSupport::Concern

    included do
      include TheSimpleSort::Base
      include ThePagination::Base
    end
  end
end
