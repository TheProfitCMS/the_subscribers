module TheSubscribers
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def crypt str
        Base64.urlsafe_encode64 str.encrypt
      end

      def decrypt str
        Base64.urlsafe_decode64(str).decrypt
      end

      def find_by_encrypted_email email
        find_by_email decrypt email
      end
    end

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

      def unactivate!
        to_unactive
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
