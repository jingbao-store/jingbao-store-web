class Api::V1::AppVersionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @app_version = AppVersion.current

    if @app_version
      render json: {
        appId: @app_version.app_id,
        latestVersion: @app_version.version_name,
        versionCode: @app_version.version_code,
        versionName: @app_version.version_name,
        updateTime: @app_version.update_time&.strftime('%Y-%m-%d'),
        downloadUrl: @app_version.final_download_url,
        fileSize: @app_version.file_size,
        fileSizeBytes: @app_version.file_size_bytes,
        minAndroidVersion: @app_version.min_android_version,
        releaseNotes: @app_version.release_notes_array,
        forceUpdate: @app_version.force_update,
        changelog: @app_version.changelog
      }
    else
      render json: { error: 'No version available' }, status: :not_found
    end
  end
end
