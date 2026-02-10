require 'rails_helper'

RSpec.describe "Api::CrashReports", type: :request do
  describe "POST /api/crash-report" do
    context "with crash_report type" do
      let(:valid_crash_report_attributes) do
        {
          reportType: "crash_report",
          appInfo: {
            packageName: "com.jingbao.store",
            versionName: "2.0.3",
            versionCode: 9
          },
          deviceInfo: {
            manufacturer: "vivo",
            model: "V2339A",
            androidVersion: "14",
            sdkInt: 34
          },
          crashInfo: {
            timestamp: "2026-02-10T22:30:45+08:00",
            exceptionType: "java.lang.RuntimeException",
            exceptionMessage: "exec cat push failed",
            stackTrace: "java.lang.RuntimeException: exec cat push failed\n    at com.example.Test.main(Test.java:10)"
          },
          memoryInfo: {
            availableMB: 45,
            totalMB: 128
          },
          additionalInfo: {
            usbConnected: true,
            glassesDeviceModel: "Rokid Max"
          }
        }
      end

      it "creates a new CrashReport" do
        expect {
          post "/api/crash-report", params: valid_crash_report_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        }.to change(CrashReport, :count).by(1)
      end

      it "returns success response" do
        post "/api/crash-report", params: valid_crash_report_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['message']).to eq("Crash report submitted successfully")
        expect(json_response['id']).to be_present
      end

      it "stores the crash data correctly" do
        post "/api/crash-report", params: valid_crash_report_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        crash_report = CrashReport.last
        expect(crash_report.report_type).to eq('crash_report')
        expect(crash_report.app_info['packageName']).to eq('com.jingbao.store')
        expect(crash_report.device_info['manufacturer']).to eq('vivo')
        expect(crash_report.crash_info['exceptionType']).to eq('java.lang.RuntimeException')
        expect(crash_report.memory_info['availableMB']).to eq(45)
        expect(crash_report.additional_info['usbConnected']).to be true
      end
    end

    context "with user_feedback type (with crash info)" do
      let(:valid_user_feedback_with_crash) do
        {
          reportType: "user_feedback",
          feedbackMessage: "点击安装按钮后应用闪退，无法安装任何应用",
          appInfo: {
            packageName: "com.jingbao.store",
            versionName: "2.0.3",
            versionCode: 9
          },
          deviceInfo: {
            manufacturer: "vivo",
            model: "V2339A",
            androidVersion: "14",
            sdkInt: 34
          },
          crashInfo: {
            timestamp: "2026-02-10T22:30:45+08:00",
            exceptionType: "java.lang.RuntimeException",
            exceptionMessage: "exec cat push failed",
            stackTrace: "java.lang.RuntimeException: exec cat push failed\n    at com.example.Test.main(Test.java:10)"
          },
          memoryInfo: {
            availableMB: 45,
            totalMB: 128
          },
          appLogs: "02-10 22:30:12.345 D/MainActivity: onCreate called\n02-10 22:30:12.567 I/AdbClient: USB device attached\n02-10 22:30:43.890 E/AdbClient: Failed to install APK: exec cat push failed"
        }
      end

      it "creates a new user feedback with crash info" do
        expect {
          post "/api/crash-report", params: valid_user_feedback_with_crash.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        }.to change(CrashReport, :count).by(1)
      end

      it "stores the feedback message, crash data, and app logs" do
        post "/api/crash-report", params: valid_user_feedback_with_crash.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        crash_report = CrashReport.last
        expect(crash_report.report_type).to eq('user_feedback')
        expect(crash_report.feedback_message).to eq('点击安装按钮后应用闪退，无法安装任何应用')
        expect(crash_report.crash_info['exceptionType']).to eq('java.lang.RuntimeException')
        expect(crash_report.app_logs).to include('E/AdbClient: Failed to install APK')
      end
    end

    context "with user_feedback type (without crash info)" do
      let(:valid_user_feedback_only) do
        {
          reportType: "user_feedback",
          feedbackMessage: "建议增加深色模式支持",
          timestamp: "2026-02-10T22:30:45+08:00",
          appInfo: {
            packageName: "com.jingbao.store",
            versionName: "2.0.3",
            versionCode: 9
          },
          deviceInfo: {
            manufacturer: "vivo",
            model: "V2339A",
            androidVersion: "14",
            sdkInt: 34
          }
        }
      end

      it "creates a new user feedback without crash info" do
        expect {
          post "/api/crash-report", params: valid_user_feedback_only.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        }.to change(CrashReport, :count).by(1)
      end

      it "stores only the feedback message" do
        post "/api/crash-report", params: valid_user_feedback_only.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        crash_report = CrashReport.last
        expect(crash_report.report_type).to eq('user_feedback')
        expect(crash_report.feedback_message).to eq('建议增加深色模式支持')
        expect(crash_report.crash_info).to be_nil
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          reportType: "invalid_type",
          appInfo: nil,
          deviceInfo: nil
        }
      end

      it "does not create a new CrashReport" do
        expect {
          post "/api/crash-report", params: invalid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        }.to change(CrashReport, :count).by(0)
      end

      it "returns error response" do
        post "/api/crash-report", params: invalid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end
    end
  end
end
