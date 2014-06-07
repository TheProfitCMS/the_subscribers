module TheSubscribers
  module Crypt
    extend ActiveSupport::Concern

    included do
      def crypt data
        data.encrypt!
        Base64.urlsafe_encode64(data)
      end

      def decrypt data
        data = Base64.urlsafe_decode64(data)
        data.decrypt
      end
    end
  end
end
