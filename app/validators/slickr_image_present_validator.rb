class SlickrImagePresentValidator < ActiveModel::Validator
  def validate(record)
    unless !options[:required] || record.send(options[:method_symbol]).nil?
      return unless record.send(options[:method_symbol]).slickr_media_upload_id.nil? ||
         record.send(options[:method_symbol]).slickr_media_upload_id.zero? ||
         record.send(options[:method_symbol]).slickr_media_upload_id.blank?
      record.errors.add(options[:method_symbol], "can't be blank")
    end
  end
end
