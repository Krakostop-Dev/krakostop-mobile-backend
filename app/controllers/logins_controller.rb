class LoginsController <  ApplicationController
  def create
    payload = login_user.call(google_token)
    status = :ok
  rescue GoogleTokenError => e
    payload = {error: e.message}
    status = :bad_request
  rescue GoogleEndpointError => e
    payload = {error: e.message}
    status = :service_unavailable
  ensure
    render(json: payload, status: status)
  end

  private

  def google_token
    params.require(:token)
  end

  def login_user
    Login::LoginUser.new
  end
end