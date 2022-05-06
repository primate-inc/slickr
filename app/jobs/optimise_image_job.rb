class OptimiseImageJob < ApplicationJob
  after_perform do |job|
    job.arguments.first.create_thumbnails!
  end
  def perform(record)
    if record.image_data.present?
      image_optim = ImageOptim.new(
        pngout: false,
        jpegoptim: { allow_lossy: true, max_quality: 85 }
      )

      record.image_attacher.file.open do |io|
        optimized_path = image_optim.optimize_image(io)
        optimized_path.open do |oo|
          record.image_attacher.merge_derivatives record.image_attacher.upload_derivatives({ optimised: oo })
        end
      end
      record.save
    end
  end
end
