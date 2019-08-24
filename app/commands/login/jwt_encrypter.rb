module Login
  class JwtEncrypter
    def call(user)
      payload = { user_id: user.id }
      secret = Rails.application.credentials.jwt_secret_key
      JWT.encode(payload, secret, 'HS256')
    end
  end
end
