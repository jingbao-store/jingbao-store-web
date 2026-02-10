require 'rails_helper'

RSpec.describe "Api::CrashReports", type: :request do
  describe "POST /api/crash-report" do
    let(:valid_attributes) do
      {
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

    let(:invalid_attributes) do
      {
        appInfo: nil,
        deviceInfo: nil,
        crashInfo: nil
      }
    end

    context "with valid parameters" do
      it "creates a new CrashReport" do
        expect {
          post "/api/crash-report", params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        }.to change(CrashReport, :count).by(1)
      end

      it "returns success response" do
        post "/api/crash-report", params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be true
        expect(json_response['message']).to eq("Crash report submitted successfully")
        expect(json_response['id']).to be_present
      end

      it "stores the crash data correctly" do
        post "/api/crash-report", params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        
        crash_report = CrashReport.last
        expect(crash_report.app_info['packageName']).to eq('com.jingbao.store')
        expect(crash_report.device_info['manufacturer']).to eq('vivo')
        expect(crash_report.crash_info['exceptionType']).to eq('java.lang.RuntimeException')
        expect(crash_report.memory_info['availableMB']).to eq(45)
        expect(crash_report.additional_info['usbConnected']).to be true
      end
    end

    context "with invalid parameters" do
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
