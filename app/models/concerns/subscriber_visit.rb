module TheSubscribers
  module SubscriberVisitModel
    extend ActiveSupport::Concern

    # shortcat for kaminary pagination
    module ClassMethods
      def pagination params
        page(params[:page]).per(params[:per_page])
      end
    end

    included do
      include BaseSorts
    end
  end
end
