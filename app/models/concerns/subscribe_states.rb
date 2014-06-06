module SubscribeStates
  extend ActiveSupport::Concern

  # unactive | active | unconfirmed
  included do
    state_machine :initial => :unactive do
      event :to_active do
        # regenerate key
        transition any => :active
      end

      event :to_unactive do
        transition any => :unactive
      end

      event :to_unconfirmed do
        transition any => :unconfirmed
      end
    end
  end
end
