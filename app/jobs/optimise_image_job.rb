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

      tempfile = record.image_attacher.file.download

      File.open(tempfile.path) do |io|
        optimized_path = image_optim.optimize_image(io)

        if optimized_path.present?
          File.open(optimized_path.to_s) do |file|
            record.image_attacher.add_derivative(:optimised, file)
          end
        else
          record.image_attacher.add_derivative(:optimised, io)
        end
        record.image_attacher.atomic_persist
      end
    end
    record.save
  end
end
