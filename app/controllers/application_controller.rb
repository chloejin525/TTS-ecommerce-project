class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :all_categories, :all_brands
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  
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

  

  private
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end


  
end
