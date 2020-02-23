class User < ApplicationRecord
  belongs_to :pair

  has_one_attached :avatar

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true

  delegate :finished?, to: :pair

  def serializable_hash(options = {})
    super(options)
        .except('verification_code')
        .merge(avatar: avatar_icon_url)
  end

  def avatar_icon_url
    GenerateAvatarIconUrl.new.call(avatar)
  end
end
