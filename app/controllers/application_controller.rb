class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :all_categories, :all_brands, :cart_quantity
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  
  #if some method is defined as helper_method, the view will be able to use the method (just like current_user)
  helper_method :current_order

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end

  def all_categories
    @all_categories = []
  	Category.order(:name).each do |c|
      @all_categories << c if c.name != "Other"
    end
      @all_categories << Category.find_by(name: "Other")
  end

  def all_brands
  	@all_brands = Product.pluck(:brand).sort.uniq
  end

  def cart_quantity
    #need to change here if no LineItem destroy all
    @cart_quantity = 0
    LineItem.all.each do |item|
      @cart_quantity += item.quantity
    end
  end
  

  private
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end


  
end
