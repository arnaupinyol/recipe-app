module AttachmentUrlHelper
  module_function

  def url_for(attachment, base_url: nil)
    return unless attachment.attached?

    if base_url.present?
      Rails.application.routes.url_helpers.rails_blob_url(attachment, host: base_url)
    else
      Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
    end
  end
end
