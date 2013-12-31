require 'warehouse/prefetch_craftsmen'

class SessionsController < ApplicationController
  layout "sessions_layout"

  def create
    begin
      auth_hash = request.env["omniauth.auth"]
      user    = repo.user.find_or_create_by_auth_hash(auth_hash) rescue nil

      prefetch_craftsmen(auth_hash)
      build_sessions(user, auth_hash)
      flash[:notice] = "Signed in successfully."
      redirect_target = session[:return_to] || root_path
      redirect_to redirect_target
    rescue Warehouse::AuthenticationError, Warehouse::AuthorizationError => e
      display_authorization_message_and_log_exception(e)
      redirect_to oauth_signin_path
    rescue Exception => e
      display_message_and_log_exception("There was a problem when logging in. Please contact it@abcinc.com.", e)
      redirect_to oauth_signin_path
    end
  end

  def oauth_signin
  end

  def destroy
    session.delete(:user_id)
    session.delete(:id_token)
    redirect_to oauth_signin_path
  end

  private

  def valid_auth_hash?(auth_hash)
    auth_hash[:extra][:id_token].present? &&
    auth_hash[:info][:email].present? &&
    auth_hash[:uid].present?
  rescue StandardError => e
    false
  end

  def build_sessions(user, auth_hash)
    session[:user_id]  = user.id
    session[:id_token] = auth_hash[:extra][:id_token]
  end

  def prefetch_craftsmen(auth_hash)
    Warehouse::PrefetchCraftsmen.new.execute(auth_hash[:extra][:id_token]) if Rails.application.config.prefetch_craftsmen
  end

  def display_authorization_message_and_log_exception(exception)
    message = "You are not authorized to view this page. " +
      "Only ABC, Inc. craftsmen are authorized to view this page. " +
      "If you are one, please contact us."

    display_message_and_log_exception(message, exception)
  end

  def display_message_and_log_exception(message, exception)
    flash[:error] = [message]
    Rails.logger.error message
    Rails.logger.error exception.class.to_s
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace
  end
end
