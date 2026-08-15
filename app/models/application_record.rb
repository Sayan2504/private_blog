class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # If manually constructing a 16-byte key for AES-128:
  raw_secret = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
  key = Digest::SHA256.digest(raw_secret.to_s)[0..15] if raw_secret.present?
end