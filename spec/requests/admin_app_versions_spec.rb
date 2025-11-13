require 'rails_helper'

RSpec.describe "Admin::AppVersions", type: :request do
  before { admin_sign_in_as(create(:administrator)) }

  describe "GET /admin/app_versions" do
    it "returns http success" do
      get admin_app_versions_path
      expect(response).to be_success_with_view_check('index')
    end
  end

end
