class CreateImageThumbnailsJob < ApplicationJob
  after_perform do |job|
    job.arguments.first.resize!
  end
  def perform(record)
    if record.image_data.present?
      attacher = record.image_attacher

      svg = record.image.mime_type.include?('svg')

      if svg
        attacher.add_derivative(:thumb_200x200, record.image(:optimised).download)
        attacher.add_derivative(:thumb_400x400, record.image(:optimised).download)
        attacher.add_derivative(:thumb_800x800, record.image(:optimised).download)
      else
        record.image(:optimised).open do |io|
          pipeline = ImageProcessing::Vips.source(io)
          attacher.add_derivative(:thumb_200x200, pipeline.resize_and_pad(200, 200, extend: :white).call)
          attacher.add_derivative(:thumb_400x400, pipeline.resize_and_pad(400, 400, extend: :white).call)
          attacher.add_derivative(:thumb_800x800, pipeline.resize_and_pad(800, 800, extend: :white).call)
        end
      end
      record.save
    end
  end
end
