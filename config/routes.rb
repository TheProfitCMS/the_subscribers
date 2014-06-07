module TheSubscribers
  class Routes
    def self.mixin mapper
      mapper.get  "unsubscribe/:email" => 'subscribers#unsubscribe',  as: :unsubscribe

      mapper.resources :subscribers do
        mapper.member do
          mapper.get :confirm
        end
      end
    end
  end
end
