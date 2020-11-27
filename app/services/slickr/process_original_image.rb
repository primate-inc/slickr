class Slickr::ProcessOriginalImage
  def call(attacher)
    original  = attacher.file
    processed = original

    uploaded_file = attacher.upload processed,
      metadata: { "filename" => original["filename"] },
      delete: true

    attacher.set(uploaded_file)
    attacher.persist # calls `record.save`
  end
end
