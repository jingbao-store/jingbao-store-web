class Admin::ApplicationsController < Admin::BaseController
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Application.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    
    # 如果上传了 APK 文件，自动计算文件大小
    @application.update_file_size_from_apk if @application.apk_file.attached?

    if @application.save
      redirect_to admin_application_path(@application), notice: 'Application was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # 如果上传了新的 APK 文件，自动计算文件大小
    if application_params[:apk_file].present?
      @application.apk_file.attach(application_params[:apk_file])
      @application.update_file_size_from_apk
    end
    
    if @application.update(application_params.except(:apk_file))
      redirect_to admin_application_path(@application), notice: 'Application was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @application.destroy
    redirect_to admin_applications_path, notice: 'Application was successfully deleted.'
  end

  private

  def set_application
    @application = Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:name, :package_name, :version, :description, :icon, :apk_file, :download_url, :file_size, :file_size_bytes, :developer, :rating, :downloads, :last_updated, :min_android_version, :permissions, :features, :category_id, screenshots: [])
  end
end
