module TheSubscribers
  module Model
    extend ActiveSupport::Concern

    included do
      include TheSimpleSort::Base
      include ThePagination::Base

      validate :email_format
      validates_presence_of   :email
      validates_uniqueness_of :email, case_sensitive: false

      # unactive | active
      state_machine :initial => :unactive do
        event :to_active do
          transition any => :active
        end

        event :to_unactive do
          transition any => :unactive
        end
      end

      def send_subscribe_request
        SubscribeMailer.subscribe_request(self).deliver
      end

      def send_unsubscribe_request
        SubscribeMailer.unsubscribe_request(self).deliver
      end

      private

      def email_format
        if self.email.present?
          errors.add(:email, I18n.t('subscribers.email_format')) unless self.email.match(/\A\S+@\S+\.\S+\z/mix)
        end
      end
    end
  end
end
