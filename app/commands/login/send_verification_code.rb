module Login
  class SendVerificationCode
    def initialize(create_pair: DownloadAndCreatePair.new)
      @download_and_create_pair = create_pair
    end

    def call(email:, pair_nr:)
      user = find_user(email, pair_nr)
      unless user
        download_and_create_pair.call!(email: email, pair_nr: pair_nr)
        user = find_user(email, pair_nr)
      end

      generate_verification_code(user)
      ::UserMailer.verification_code(user: user).deliver_now
    rescue MissingData
      raise(LoginUnauthorizedError, 'Wrong credentials')
    end

    private

    attr_reader :download_and_create_pair

    def find_user(email, pair_nr)
      User.joins(:pair).find_by(email: email, pairs: {pair_nr: pair_nr})
    end

    def generate_verification_code(user)
      code = rand(10 ** 6).to_s
      puts(code)
      user.update!(verification_code: code)
    end
  end
end