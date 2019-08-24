module Login
  class GoogleTokenVerifier
    include HTTParty
    base_uri 'https://oauth2.googleapis.com'

    def call(token)
      Retryable.retryable(tries: 3, on: GoogleEndpointError) do
        response = perform_request(token)
        validate_response(response)
        return response
      end
    end

    private

    def perform_request(token)
      self.class.get("/tokeninfo", { query: { id_token: token } })
    rescue HTTParty::Error, SocketError
      raise(GoogleEndpointError, 'Error connecting to Google')
    end

    def validate_response(response)
      case response.code.to_s
      when /^[4]\d{2}/
        raise(GoogleTokenError, 'Invalid token')
      when /^[5]\d{2}/
        raise(GoogleEndpointError, 'Google Error')
      end
    end
  end
end