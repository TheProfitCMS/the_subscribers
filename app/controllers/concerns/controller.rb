module TheSubscribers
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_subscriber_by_encrypted_email, only: %w[ subscribe unsubscribe ]
      before_action :set_subscriber,                    only: %w[ show edit update destroy ]
      before_action :set_subscriber_by_email,           only: %w[ subscribe_request unsubscribe_request ]

      def requests_timeout
        5.minutes.ago
      end

      def create
        @subscriber = Subscriber.where(email: params[:subscriber][:email]).first_or_initialize

        if @subscriber.new_record? && @subscriber.valid?
          @subscriber.save
          @subscriber.send_subscribe_request
          message = "Вам отправлено письмо для подтверждения действий с подпиской"
          return redirect_to root_path, { flash: { notice: message } }
        end

        unless @subscriber.save
          return redirect_to root_path, { flash: { errors: @subscriber.errors.to_a } }
        end

        subscribe_request
      end

      def subscribe_request
        message = if @subscriber.active?
          "Подписка уже активна"
        else
          if @subscriber.updated_at < requests_timeout
            @subscriber.touch
            @subscriber.send_subscribe_request
            "Вам отправлено письмо для подтверждения действий с подпиской"
          else
            "Недавно уже выполнялись действия с подписками. Пожалуйста, подождите несколько минут и посторите попытку."
          end
        end

        return redirect_to root_path, { flash: { notice: message } }
      end

      def unsubscribe_request
        message = if @subscriber.unactive?
          "Подписка не активна"
        else
          if @subscriber.updated_at < requests_timeout
            @subscriber.touch
            @subscriber.send_unsubscribe_request
            "Вам отправлено письмо для подтверждения действий с подпиской"
          else
            "Недавно уже выполнялись действия с подписками. Пожалуйста, подождите несколько минут и посторите попытку."
          end
        end

        redirect_to root_path, { flash: { notice: message } }
      end

      # get "subscribe/:id"
      def subscribe
        message = if @subscriber.active?
          "Подписка уже активирована"
        else
          @subscriber.to_active
          "Подписка успешно активирована"
        end

        redirect_to root_path, { flash: { notice: message } }
      end

      # get "unsubscribe/:id"
      def unsubscribe
        message = if @subscriber.unactive?
          "Подписка уже остановлена"
        else
          @subscriber.to_unactive
          "Подписка успешно остановлена"
        end

        redirect_to root_path, { flash: { notice: message } }
      end

      # MODERATOR INTERFACE

      def index
        @subscribers = Subscriber.order('id DESC').pagination params
      end

      def full_list
        @subscribers = Subscriber.old.all
        render 'subscribers_list'
      end

      def active_list
        @subscribers = Subscriber.old.where(state: :active)
        render 'subscribers_list'
      end

      def new
        @subscriber = Subscriber.new
      end

      def show; end
      def edit; end

      def update
        @subscriber.assign_attributes(subscriber_params)

        if @subscriber.send("to_#{ @state }")
          redirect_to subscribers_path, notice: t('.updated')
        else
          render action: :edit
        end
      end

      def delete_selected
        if (selected = params[:selected]).present?
          ids = selected.split(',')
          Subscriber.where(id: ids).destroy_all
        end

        render nothing: true
      end

      def destroy
        @subscriber.destroy
        redirect_to subscribers_url
      end

      private

      def set_subscriber_by_email
        @subscriber ||= Subscriber.where(email: params[:subscriber][:email]).first
        return redirect_to root_path, { flash: { alert: "Запись не найдена" } } unless @subscriber
      end

      def set_subscriber_by_encrypted_email
        @subscriber = Subscriber.find_by_email params[:email].to_the_decrypted
        return redirect_to root_path, { flash: { alert: "Запись не найдена" } } unless @subscriber
      end

      def set_subscriber
        @subscriber = Subscriber.find params[:id]
      end

      def subscriber_params
        params.require(:subscriber).permit(:email, :state)
      end
    end
  end
end
