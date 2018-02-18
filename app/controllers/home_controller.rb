class HomeController < ApplicationController
  before_action :check_errors
  def index
  
  end

  private

  def check_errors(params = {})
    if params[:error]
      flash[:alert] = params[:error]
    end
  end

end
