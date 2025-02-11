# frozen_string_literal: true

# this is the base controller for my application, all controllers
# inherit from here
class ApplicationController < ActionController::Base
  # Ensure User is authorized to access route using Pundit
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  protect_from_forgery with: :exception

  # rubocop:disable Rails/LexicallyScopedActionFilter
  # These methods are defined on many controllers and user should be
  # authenticated prior to using them.
  before_action :authenticate_user!, only: %i[create new update edit destroy]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
