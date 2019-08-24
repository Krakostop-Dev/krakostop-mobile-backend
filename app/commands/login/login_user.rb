module Login
  class LoginUser
    def initialize(google_token_verifier: GoogleTokenVerifier.new,
                   user_fetcher: UserFetcher.new,
                   jwt_encrypter: JwtEncrypter.new)
      @google_token_verifier = google_token_verifier
      @user_fetcher = user_fetcher
      @jwt_encrypter = jwt_encrypter
    end

    def call(google_token)
      validate_token_presence(google_token)

      user_data = google_token_verifier.call(google_token)
      user = user_fetcher.call(user_data)
      token = jwt_encrypter.call(user)

      {token: token, user: user}
    end

    private

    attr_reader :google_token_verifier, :user_fetcher, :jwt_encrypter

    def validate_token_presence(token)
      raise(GoogleTokenError, 'Google token is missing') unless token.present?
    end
  end
end
