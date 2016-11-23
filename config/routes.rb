Rails.application.routes.draw do

  get 'profiles/index'

  namespace :admin do  end

  #namespace :admin do
  #get 'contact_mailer_information/index'
  #end

  namespace :admin do
  get 'payment_addresses/index'
  end

  get 'home/index'
  get 'home/go_home'
  get 'admin/codes/index'
  get "admin/codes/con-index" => "admin/codes#con_index"
  get 'admin/codes/con_index'
  get 'web_services/index'

  get "/admin" => "admin/home#index"
  get "/admin/jobs/upload_video/:id" => "admin/jobs#upload_video"
  get "/admin/completed_job/:id" => "admin/jobs#completed_job"
  get "/admin/job_details/:id" => "admin/jobs#job_details"
  get "/successed-order/:uid/:cid/:jid" => "celeberties#order_success"
  get "/update-order/:cid/:jid" => "celeberties#order_updated"
  get "/status-pending/:jid" => "celeberties#status_pending"
  get "/job/complete_job/:id" => "jobs#complete_job"
  get "/privacy_policies" => "celeberties#privacy_policy"
  get "/privacy-policy" => "celeberties#privacy_policy"
  get "/thank-notes" => "celeberties#after_contact_us"
  get "/terms-of-use" => "celeberties#terms_of_services"
  get "/search-celebrities" => "celeberties#index"
  get "/celebrities" => "celeberties#search_celebrities"
  get "/how-it-works" => "celeberties#how_it_works"
  get "/contact-us" => "celeberties#contact_us_page"
  get "/fqs" => "celeberties#fqs"
  get "/our-team" => "celeberties#our_team_page"
  get "/celebrities/:id" => "celeberties#show"
  get "/celebrities/fqs"  => "celeberties#fqs"
  get "/my-account"  => "celeberties#my_account"
  get "/forget/password/:id/:token" => "users/passwords#edit_pass"
  # get "/users/password/edit" => "users/passwords#edit_pass"

  #devise_for :users
  namespace :admin do
    get 'home/index'

    resources :contact_mailer_information do
      collection do
      post "reply_email"
      get "reply_email"
    end
    end

    resources :profile do
      collection do
        get "index"
        #get "add_user"
        #get "edit_user"
        post "create_profile"
        post "update_profile"
        patch "update_profile"
        get "create_profile"
        get "all-profiles"
        #get "show"
        #delete "destroy"
        #post "admin/users/active_deactive_user"
        get "active_deactive_profile"

      end
    end

    resources :users do
      collection do
        #get "add_user"
        #get "edit_user"
        post "create_user"
        post "update_user"
        patch "update_user"
        get "create_user"
        get "all-users"
        #get "show"
        #delete "destroy"
        #post "admin/users/active_deactive_user"
        get "active_deactive_user"
      end
    end

    resources :codes

    resources :celebrities do
      collection do
        get "edit"
        post "create_celebrity"
        get "add_celebrity"
        post "add_celebrity_detail"
        post "update_celebrity"
        get "get_celebrity_details"
        patch "update_celebrity_details"
        post "update_celebrity_details"
        get "create_celebrity"
        get "all-celebrities"
        get "active_deactive_celebrity"
        get "approve_introduction_video_by_admin"
        get "reject_introduction_video_by_admin"
      end
    end

    resources :jobs do
      collection do
        get "index"
        get "approve_job_by_admin"
        get "reject_job_by_admin"
        get "celebrity-completed-jobs"
        get "deadline_missed_jobs"
        get "approve_video_by_admin"
        get "reject_video_by_admin"

      end
    end

    resources :event_types do
      collection do
        get "index"
      end
    end

    resources :charity_accounts do
      collection do
        get "payment-index"
        get "new-payment"
        post "celebrity_charity_accounts"
      end
    end

  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  devise_for :users, :controllers => {
      :sessions => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords => "users/passwords",
      :unlocks => "users/unlocks",
      :omniauth => "users/omniauth_callbacks",
      :registrations => "users/registrations"
      #
  }
  devise_scope :user do
    #get "admin", :to => "devise/sessions#new"
    #get "sign-in", :to => "users/sessions#new"
    # get 'sign_in', :to => 'users/sessions#new', :as => :new_session
    get "/users/sign_out", :to => "users/sessions#destroy"
    get "/users/admin_sign_in", :to => "users/sessions#admin_sign_in"
    #post "sign-out", :to => "users/sessions#destroy"
    #get "sign-up", :to => "users/registrations#new"
    # patch "/users/update_user", :to =s> "users/registrations#update_user"
    #get "login", :to => "devise/sessions#login"
  end

  resources :web_services do
    collection do
      get :update_password
      get :get_all_celebrities
      get :get_celebrity_profile
      get :search_celebrity_by_name_or_industry
      get :create_job
      get :create_transaction
      get :forgot_password
      post :create_an_account
      post :create_transactions
      get :get_all_industries
      get :get_user_profile
      get :get_all_event_types
      get :get_user_purchazes
      get :get_job_purchazed_details
      #post :user_sign_up
      #post :user_sign_up_facebook
      #get :add_credit_card_payment_method
      #get :fetch_customer_payment_methods
      #get :fetch_credit_card_payment_method
      #get :update_credit_card_payment_method
      #get :search_filtered_celebrities
      #get :add_payment_and_create_job
      #get :send_user_information
      #---------------------------------------------
      #for celebrities
      #---------------------------------------------
      get :get_pending_jobs_of_celebrity
      get :get_completed_jobs_of_celebrity
      get :get_job_details
      get :get_profile_of_celebrity
      post :update_profile_image_of_celebrity
      get :update_profile_of_celebrity
      get :get_pending_or_completed_jobs_of_celebrity
      get :upload_video
      get :reject_job
      get :update_push_notification
      get :update_away_mode
      get :update_charity_rate
      get :update_celebrity_rate
      get :update_monthly_videos_count
      get :get_profile_description_of_celebrity
      get :update_profile_description_of_celebrity
      get :update_email_of_celebrity
      get :get_payment_address_of_celebrity
      get :update_payment_address_of_celebrity
      get :update_merchant_of_celebrity_on_braintree
      get :get_shorten_url_of_profile
      get :submit_agent_code
      get :check_device_code
      get :update_payment_info
      #below routes are used for testing
      get :check_twitter_celebrity
      get :test_service
      #get :add_credit_card_payment_method
      get :test_function
      get :push_testing
      get :push_testinga
      get :push_testingb
      get :push_testingc
      get :get_customer_order_details
      get :update_customer_order_details
      get :testtt
      get :test_url
      get :testabc


    end
  end

  resources :celeberties do
    collection do
      get 'index'
      get 'show'
      get 'search_celeberty'
      get 'searching'
      post 'searching_from_index'
      get 'order_success'
      get 'user_account'
      get 'edit_pass'
      patch 'update_pass'
      get 'static_pages'
      get 'get_video'
      get 'check_email'
      get 'cart'
      post 'contact_mail'
      get 'check_order'
      get 'pending_status'
      get "celebrity_video"
      get "pending_status"
      get "ping_to_server"
      #get 'celeb_detail'
      #post 'job_create'
    end
  end

  resources :jobs do
    collection do
      #get 'celeb_msg_detail'
      post 'job_create'
      post 'job_update'
      post 'billing_info'
      get "delete_job"
      post "delete_job"
      post "update_rejected_job"
    end
  end

  resources :profiles do
    collection do

    end
  end

  resources :home do
    collection do
      get 'searching'

    end
  end
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
