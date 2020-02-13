class LoginsController < ApplicationController
  def create
    Login::SendVerificationCode.new.call(create_params)
    render(json: {}, status: :ok)
  rescue LoginError => e
    render(json: { error: e.message }, status: :service_unavailable)
  rescue LoginUnauthorizedError => e
    render(json: { error: e.message }, status: :unauthorized)
  end

  def update
    user = User.find_by(update_params)
    if user.present?
      token = Login::JwtEncrypter.new.call(user)
      render(json: { token: token, user: user },
             status: :ok)
    else
      render(json: { error: 'No user matching credentials' },
             status: :unauthorized)
    end
  end

  private

  def create_params
    params.require(%i[email pair_nr])
  end

  def update_params
    params.require(%i[email verification_code])
  end
end
