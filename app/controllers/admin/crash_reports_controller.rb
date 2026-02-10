class Admin::CrashReportsController < Admin::BaseController
  before_action :set_crash_report, only: [:show, :destroy]

  def index
    @crash_reports = CrashReport.recent.page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    @crash_report.destroy
    redirect_to admin_crash_reports_path, notice: 'Crash report was successfully deleted.'
  end

  private

  def set_crash_report
    @crash_report = CrashReport.find(params[:id])
  end
end
