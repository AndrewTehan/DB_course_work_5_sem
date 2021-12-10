# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :require_login, unless: :devise_controller?
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActionController::RoutingError, with: -> { render_404 } unless Rails.application.config.consider_all_requests_local
  rescue_from ActiveRecord::RecordNotFound, with: -> { render_404 } unless Rails.application.config.consider_all_requests_local

  protected
  def connection_execute sql_query
    ActiveRecord::Base.connection.execute("#{sql_query}")
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :phone_number, :type) }
  end

  private

  def require_login
    redirect_to new_user_session_path unless current_user
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
