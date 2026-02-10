class CrashReport < ApplicationRecord
  # Validations
  validates :app_info, :device_info, presence: true
  validates :report_type, presence: true, inclusion: { in: %w[crash_report user_feedback] }
  validates :crash_info, presence: true, if: -> { report_type == 'crash_report' }
  validates :feedback_message, presence: true, if: -> { report_type == 'user_feedback' }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_package, ->(package_name) { where("app_info->>'packageName' = ?", package_name) }
  scope :by_exception_type, ->(exception_type) { where("crash_info->>'exceptionType' = ?", exception_type) }
  scope :crash_reports, -> { where(report_type: 'crash_report') }
  scope :user_feedbacks, -> { where(report_type: 'user_feedback') }
end
