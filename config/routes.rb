module TheSubscribers
  class Routes
    def self.mixin mapper
      mapper.get  "unsubscribe/:email" => 'subscribers#unsubscribe',  as: :unsubscribe
      mapper.get  "subscribe/:email"   => 'subscribers#subscribe',    as: :subscribe

      mapper.resources :subscriber_visits, only: [:index]

      mapper.resources :subscribers do
        mapper.collection do
          mapper.get :full_list
          mapper.get :active_list

          mapper.post   :unsubscribe_request
          mapper.delete :delete_selected
        end
      end
    end
  end
end
