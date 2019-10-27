class ProtectedController < ApplicationController
  before_action :authenticate_user
  helper_method :current_user

  protected

  attr_reader :current_user

  private

  def authenticate_user
    @current_user = User.find(user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render(json: {error: "Unauthorized" }, status: :unauthorized)
  end

  def user_id
    payload = decrypt_jwt(bearer_token)
    payload[:user_id]
  end

  def decrypt_jwt(token)
    Login::JwtDecrypter.new.call(token)
  end

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers.fetch('Authorization', nil)
    header.gsub(pattern, '') if header&.match(pattern)
  end
end
