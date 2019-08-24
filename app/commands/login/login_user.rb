module Login
  class LoginUser
    def initialize(google_token_verifier: GoogleTokenVerifier.new,
                   user_fetcher: UserFetcher.new)
      @google_token_verifier = google_token_verifier
      @user_fetcher = user_fetcher
    end

    def call(google_token)
      validate_token_presence(google_token)

      user_data = google_token_verifier.call(google_token)
      user = user_fetcher.call(user_data)

    end

    private

    attr_reader :google_token_verifier, :user_fetcher

    def validate_token_presence(token)
      raise(GoogleTokenError, 'Google token is missing') unless token.present?
    end
  end
end