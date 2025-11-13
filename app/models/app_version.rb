class AppVersion < ApplicationRecord
  validates :app_id, presence: true
  validates :version_name, presence: true
  validates :version_code, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :download_url, presence: true
  validates :file_size, presence: true
  validates :file_size_bytes, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :latest, -> { order(version_code: :desc).first }
  scope :by_app_id, ->(app_id) { where(app_id: app_id) }

  def release_notes_array
    release_notes.present? ? JSON.parse(release_notes) : []
  rescue JSON::ParserError
    []
  end

  def self.current
    order(version_code: :desc).first
  end
end
