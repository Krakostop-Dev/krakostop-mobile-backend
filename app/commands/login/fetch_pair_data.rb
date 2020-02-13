module Login
  class FetchPairData
    API_URL = 'https://www.krakostop.eu/api'.freeze

    def call(email:, pair_nr:)
      response = HTTParty.get(API_URL, query: query_params(email, pair_nr))
      body_hash = JSON.parse(response.body, symbolize_names: true)
      body_hash[:result]
    rescue HTTParty::Error, SocketError
      raise(LoginError, 'Something went wrong')
    end

    private

    def query_params(email, pair_nr)
      {
        method: 'check_email',
        login: 'krako_api',
        password: 2_215_885_154,
        email: email,
        nr_pair: pair_nr
      }
    end
  end
end