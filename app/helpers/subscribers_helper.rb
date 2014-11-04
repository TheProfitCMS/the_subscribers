module SubscribersHelper
  def subscriber_states
    %w[ active unactive ].collect{ |state| [ t("admin.subscribers.select_states.#{ state }"), state ] }
  end

  def get_subscriber_state subscriber
    subscriber.active? ? 'active' : 'unactive'
  end

  def state_color state
    case state
    when :active
      :success
    when :unactive
      :warning
    when :unconfirmed
      :danger
    end
  end
end
