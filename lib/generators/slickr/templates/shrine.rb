require 'shrine'
require 'shrine/storage/file_system'
# require 'shrine/storage/s3'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new("public", prefix: 'uploads/store')
  # backup_store: Shrine::Storage::S3.new(
  #   prefix: "backup/#{Rails.env}",
  #   access_key_id: Rails.application.credentials.s3_key,
  #   secret_access_key: Rails.application.credentials.s3_secret,
  #   region: Rails.application.credentials.s3_region,
  #   bucket: Rails.application.credentials.s3_bucket
  # )
}

# ORM
Shrine.plugin :activerecord

# Model
Shrine.plugin :cached_attachment_data # retain cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :remove_attachment # delete attachments through checkboxes on the web form
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives,
  create_on_promote:      false, # automatically create derivatives on promotion
  versions_compatibility: true  # handle versions column format

# Metadata
Shrine.plugin :add_metadata # Allows extracting additional metadata values
Shrine.plugin :determine_mime_type # stores the MIME type of the uploaded file
Shrine.plugin :infer_extension # Deduce appropriate file extension based on the MIME type
Shrine.plugin :refresh_metadata # Allows re-extracting metadata of an uploaded file
Shrine.plugin :restore_cached_data # Re-extracts cached file's metadata on model assignment

# Storage
Shrine.plugin :pretty_location # more organized directory structure on the storage
# Shrine.plugin :backup, storage: :backup_store

# Other
Shrine.logger = Rails.logger

class Shrine::Attacher
  def promote(*)
    create_derivatives
    super
  end
end

