class GenerateAvatarIconUrl
  include Rails.application.routes.url_helpers

  def call(avatar)
    return nil unless avatar.present?

    variant = avatar.variant(resize: "100x100").processed
    rails_representation_url(variant, only_path: true)
  end
end