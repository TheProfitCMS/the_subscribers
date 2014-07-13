module TheSubscribers
  module States
    extend ActiveSupport::Concern

    included do
      # unactive | active
      state_machine :initial => :unactive do
        event :to_active do
          transition any => :active
        end

        event :to_unactive do
          transition any => :unactive
        end
      end
    end
  end
end
