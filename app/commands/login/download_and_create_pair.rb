module Login
  class DownloadAndCreatePair
    def initialize(fetch_pair_data: FetchPairData.new)
      @fetch_pair_data = fetch_pair_data
    end

    def call!(email:, pair_nr:)
      pair_data = fetch_pair_data.call(email: email, pair_nr: pair_nr)
      validate_data(pair_data)

      create_pair_from_data(pair_data)
    end

    private

    attr_reader :fetch_pair_data

    def validate_data(data)
      return if data.present?

      raise MissingData
    end

    def create_pair_from_data(pair_data)
      Pair.transaction do
        pair = Pair.new(pair_nr: pair_data[:nr_pair])
        build_user(pair, 1, pair_data)
        build_user(pair, 2, pair_data)
        pair.save!
      end
    end

    def build_user(pair, number, pair_data)
      pair.users.build(
        first_name: pair_data[:"name#{number}"],
        last_name: pair_data[:"surname#{number}"],
        city: pair_data[:"city#{number}"],
        phone: pair_data[:"phone#{number}"],
        email: pair_data[:"email#{number}"]
      )
    end
  end
end
