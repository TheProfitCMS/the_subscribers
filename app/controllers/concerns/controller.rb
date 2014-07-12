module TheSubscribers
  module Controller
    extend ActiveSupport::Concern

    included do
      include TheSubscribers::Crypt
      before_action :set_subscriber, only: %w[ show edit update destroy ]

      def create
        @subscriber = Subscriber.new(new_subscriber_params)

        message = if @subscriber.save
          @subscriber.send_confirm_email!
          { flash: { notice: t('.token_sended') } }
        else
          { flash: { errors: @subscriber.errors.to_a } }
        end

        redirect_to root_path, message
      end

      # get "subscribers/:token/confirm"
      def confirm
        @subscriber = Subscriber.find_by_confirmation_token params[:id]

        unless @subscriber
          return redirect_to root_path, { flash: { alert: "Запись о подписке для активации не найдена" } }
        end

        message = if @subscriber.active?
          "Подписка уже активирована"
        elsif @subscriber.unconfirmed?
          @subscriber.activate!
          "Подписка успешно активирована"
        else
          "Подписка приостановлена"
        end

        redirect_to root_path, { flash: { notice: message } }
      end

      def unsubscribe
        email = decrypt params[:email]
        @subscriber = Subscriber.find_by_email(email)

        message = if @subscriber
          @subscriber.to_unactive
          { flash: { notice: t('.unsubscribed') } }
        else
          { flash: { error: t('.bad_link') } }
        end

        redirect_to root_path, message
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

      def update
        @subscriber.update(subscriber_params)
        render action: :edit
      end

      private

      def set_subscriber
        @subscriber = Subscriber.find params[:id]
      end

      def new_subscriber_params
        params.require(:subscriber).permit(:email)
      end

      def subscriber_params
        params.require(:subscriber).permit(:email, :state)
      end
    end
  end
end
