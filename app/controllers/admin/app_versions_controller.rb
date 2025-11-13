class Admin::AppVersionsController < Admin::BaseController
  before_action :set_app_version, only: [:show, :edit, :update, :destroy]

  def index
    @app_versions = AppVersion.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @app_version = AppVersion.new
  end

  def create
    @app_version = AppVersion.new(app_version_params)
    convert_release_notes_to_json(@app_version)

    if @app_version.save
      redirect_to admin_app_version_path(@app_version), notice: 'App version was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @app_version.assign_attributes(app_version_params)
    convert_release_notes_to_json(@app_version)
    
    if @app_version.save
      redirect_to admin_app_version_path(@app_version), notice: 'App version was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @app_version.destroy
    redirect_to admin_app_versions_path, notice: 'App version was successfully deleted.'
  end

  private

  def set_app_version
    @app_version = AppVersion.find(params[:id])
  end

  def app_version_params
    params.require(:app_version).permit(:app_id, :version_name, :version_code, :update_time, :download_url, :file_size, :file_size_bytes, :min_android_version, :release_notes, :changelog, :force_update)
  end

  def convert_release_notes_to_json(app_version)
    if app_version.release_notes.present? && !app_version.release_notes.start_with?('[')
      notes_array = app_version.release_notes.split("\n").map(&:strip).reject(&:blank?)
      app_version.release_notes = notes_array.to_json
    end
  end
end
