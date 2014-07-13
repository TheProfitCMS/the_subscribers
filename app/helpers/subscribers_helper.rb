module SubscribersHelper
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
