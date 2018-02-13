class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def query_options
    options = {}
    options[:limit] = [params.fetch(:limit, 100).to_i, 100].min
    options[:page] = params.fetch(:page, 1)
    options
  end

end
