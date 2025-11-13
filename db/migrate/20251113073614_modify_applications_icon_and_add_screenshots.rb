class ModifyApplicationsIconAndAddScreenshots < ActiveRecord::Migration[7.2]
  def change
    # Rename icon to icon_url and change type to string (for URL)
    rename_column :applications, :icon, :icon_url
    
    # Add screenshots field as jsonb array
    add_column :applications, :screenshots, :jsonb, default: []
  end
end
