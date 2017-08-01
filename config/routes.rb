Rails.application.routes.draw do

  post 'order_complete' => 'cart#order_complete'
  post 'add_to_cart' => 'cart#add_to_cart'
  get 'all_orders' => 'cart#view_all_orders'
  get 'view_cart' => 'cart#view_cart'
  get 'checkout' => 'cart#checkout'
  get 'users' => 'users#index'
  get 'view_order' => 'cart#view_order'
 
  #a post HTTP action
  post 'users/update' => 'users#update'

  devise_for :users
  get 'categorical' => 'storefront#items_by_category'
  get 'branding' => 'storefront#items_by_brand'
  root 'storefront#all_items'

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  

end
