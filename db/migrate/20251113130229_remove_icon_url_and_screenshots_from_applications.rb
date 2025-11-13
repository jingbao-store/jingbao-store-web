class RemoveIconUrlAndScreenshotsFromApplications < ActiveRecord::Migration[7.2]
  def change
    remove_column :applications, :icon_url, :string
    remove_column :applications, :screenshots, :jsonb
  end
end
