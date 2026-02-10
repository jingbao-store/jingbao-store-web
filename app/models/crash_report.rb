class CrashReport < ApplicationRecord
  # Validations
  validates :app_info, :device_info, :crash_info, presence: true
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_package, ->(package_name) { where("app_info->>'packageName' = ?", package_name) }
  scope :by_exception_type, ->(exception_type) { where("crash_info->>'exceptionType' = ?", exception_type) }
end
