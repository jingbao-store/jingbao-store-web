FactoryBot.define do
  factory :app_version do

    app_id { "MyString" }
    version_name { "MyString" }
    version_code { 1 }
    update_time { Date.today }
    download_url { "MyString" }
    file_size { "MyString" }
    file_size_bytes { nil }
    min_android_version { "MyString" }
    release_notes { "MyText" }
    changelog { "MyText" }
    force_update { true }

  end
end
