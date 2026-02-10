class CreateCrashReports < ActiveRecord::Migration[7.2]
  def change
    create_table :crash_reports do |t|
      t.jsonb :app_info
      t.jsonb :device_info
      t.jsonb :crash_info
      t.jsonb :memory_info
      t.jsonb :additional_info


      t.timestamps
    end
  end
end
