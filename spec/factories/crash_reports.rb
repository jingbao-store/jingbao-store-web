FactoryBot.define do
  factory :crash_report do
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
    
    additional_info do
      {
        usbConnected: false,
        batteryLevel: 75
      }
    end
  end
end
