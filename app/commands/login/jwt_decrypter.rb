module Login
  class JwtDecrypter
    def call(token)
      secret = Rails.application.credentials.jwt_secret_key
      decoded_data = JWT.decode(token, secret, true, { algorithm: 'HS256' })
      decoded_data.first.symbolize_keys
    end
  end
end