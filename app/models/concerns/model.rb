module TheSubscribers
  module Model
    extend ActiveSupport::Concern

    included do
      include TheSimpleSort::Base
      include ThePagination::Base
      include TheSubscribers::States

      validates_presence_of   :email
      validates_uniqueness_of :email, case_sensitive: false
      before_validation       :generate_token, on: :create
      # validates_format_of   :email, with: /\A.+@.+\..{2,5}\Z/

      def activate!
        to_active
        generate_token
        save
      end

      def send_confirm_email!
        SubscribeMailer.confirm(self).deliver
      end

      private

      def generate_token
        self.confirmation_token = SecureRandom.urlsafe_base64(10)
      end
    end
  end
end
