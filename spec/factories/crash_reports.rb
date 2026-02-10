FactoryBot.define do
  factory :crash_report do
    report_type { 'crash_report' }
    timestamp { Time.current }
    
    app_info do
      {
        packageName: "com.example.app",
        versionName: "1.0.0",
        versionCode: 1
      }
    end
    
    device_info do
      {
        manufacturer: "Samsung",
        model: "Galaxy S21",
        androidVersion: "12",
        sdkInt: 31
      }
    end
    
    crash_info do
      {
        timestamp: Time.current.iso8601,
        exceptionType: "java.lang.NullPointerException",
        exceptionMessage: "Attempt to invoke virtual method on null object",
        stackTrace: "java.lang.NullPointerException: Attempt to invoke virtual method\n    at com.example.MainActivity.onCreate(MainActivity.java:42)"
      }
    end
    
    memory_info do
      {
        availableMB: 512,
        totalMB: 2048
      }
    end
    
    app_logs { "02-10 10:30:12.345 D/MainActivity: onCreate called\n02-10 10:30:12.567 I/AppModule: Initializing\n02-10 10:30:43.890 E/CrashHandler: Fatal error occurred" }
    
    additional_info do
      {
        usbConnected: false,
        batteryLevel: 75
      }
    end
    
    trait :user_feedback do
      report_type { 'user_feedback' }
      feedback_message { "The app crashes when I try to install applications" }
      crash_info { nil }
      memory_info { nil }
      app_logs { nil }
      additional_info { nil }
    end
    
    trait :user_feedback_with_crash do
      report_type { 'user_feedback' }
      feedback_message { "点击安装按钮后应用闪退，无法安装任何应用" }
      app_logs { "02-10 22:30:12.345 D/MainActivity: onCreate called\n02-10 22:30:12.567 I/AdbClient: USB device attached\n02-10 22:30:43.890 E/AdbClient: Failed to install APK: exec cat push failed" }
    end
  end
end
