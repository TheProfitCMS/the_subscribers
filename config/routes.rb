module TheSubscribers
  class Routes
    def self.mixin mapper
      mapper.get  "unsubscribe/:email" => 'subscribers#unsubscribe',  as: :unsubscribe

      mapper.resources :subscriber_visits, only: [:index]

      mapper.resources :subscribers do
        mapper.collection do
          mapper.get :full_list
          mapper.get :active_list
          mapper.delete :delete_selected
        end

        mapper.member do
          mapper.get :confirm
        end
      end
    end
  end
end
