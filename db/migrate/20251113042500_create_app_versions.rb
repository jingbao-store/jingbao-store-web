class CreateAppVersions < ActiveRecord::Migration[7.2]
  def change
    create_table :app_versions do |t|
      t.string :app_id
      t.string :version_name
      t.integer :version_code
      t.date :update_time
      t.string :download_url
      t.string :file_size
      t.bigint :file_size_bytes
      t.string :min_android_version
      t.text :release_notes
      t.text :changelog
      t.boolean :force_update, default: false

      t.timestamps
    end

    add_index :app_versions, :app_id
    add_index :app_versions, :version_code
  end
end
