require 'rails_helper'

RSpec.describe "Admin::CrashReports", type: :request do
  before { admin_sign_in_as(create(:administrator)) }

  describe "GET /admin/crash_reports" do
    it "returns http success" do
      get admin_crash_reports_path
      expect(response).to be_success_with_view_check('index')
    end
  end

end
