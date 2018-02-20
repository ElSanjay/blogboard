class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def query_options(name)
    options = {}
    # options[:limit] = [params.fetch(:limit, 25).to_i, 100].min
    # options[:page] = params.fetch(:page, 1)
    options[:limit] = 25
    options[:page] = 1
    options[:name] = name
    options

  end

  def after_sign_in_path_for(resource)
    authentications_path
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end



end
