module Login
  class UserFetcher
    def call(user_data)
      User.find_or_create_by!(email: user_data[:email]) do |user|
        user.email = user_data[:email]
        user.first_name = user_data[:given_name]
        user.last_name = user_data[:family_name]
      end
    end
  end
end
