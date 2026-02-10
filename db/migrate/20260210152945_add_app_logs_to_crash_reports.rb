class AddAppLogsToCrashReports < ActiveRecord::Migration[7.2]
  def change
    add_column :crash_reports, :app_logs, :text

  end
end
