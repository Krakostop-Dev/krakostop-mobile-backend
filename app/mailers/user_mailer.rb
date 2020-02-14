class UserMailer < ApplicationMailer
  def verification_code(user:)
    @user = user
    mail(to: @user.email, subject: 'Krakostop Mobile login code')
  end
end
