class Api::CrashReportsController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @crash_report = CrashReport.new(crash_report_params)
    
    if @crash_report.save
      render json: { 
        success: true, 
        message: "Crash report submitted successfully",
        id: @crash_report.id
      }, status: :created
    else
      render json: { 
        success: false, 
        errors: @crash_report.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def crash_report_params
    {
      report_type: params[:reportType],
      feedback_message: params[:feedbackMessage],
      timestamp: params[:timestamp],
      app_info: params[:appInfo],
      device_info: params[:deviceInfo],
      crash_info: params[:crashInfo],
      memory_info: params[:memoryInfo],
      app_logs: params[:appLogs],
      additional_info: params[:additionalInfo]
    }
  end
end
