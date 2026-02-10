class AddReportTypeAndFeedbackMessageToCrashReports < ActiveRecord::Migration[7.2]
  def change
    add_column :crash_reports, :report_type, :string
    add_column :crash_reports, :feedback_message, :text
    add_column :crash_reports, :timestamp, :datetime

  end
end
