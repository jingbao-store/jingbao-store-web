# Crash Report & User Feedback API

## Overview

This API supports two types of reports:
1. **crash_report** - Automatic crash reports (no user feedback)
2. **user_feedback** - User-initiated feedback (may include crash logs)

## API Endpoint

```
POST /api/crash-report
```

## Request Headers

```http
Content-Type: application/json
User-Agent: JingbaoStore/2.0.3 (Android)
X-App-Version: 2.0.3
X-App-Version-Code: 9
```

## Request Format

### 1. User Feedback with Crash Log

```json
{
  "reportType": "user_feedback",
  "feedbackMessage": "点击安装按钮后应用闪退，无法安装任何应用",
  "appInfo": {
    "packageName": "com.jingbao.store",
    "versionName": "2.0.3",
    "versionCode": 9
  },
  "deviceInfo": {
    "manufacturer": "vivo",
    "model": "V2339A",
    "brand": "vivo",
    "product": "PD2339",
    "androidVersion": "14",
    "sdkInt": 34,
    "locale": "zh_CN",
    "timezone": "Asia/Shanghai"
  },
  "crashInfo": {
    "timestamp": "2026-02-10T22:30:45+08:00",
    "timestampMs": 1739196645000,
    "threadName": "main",
    "threadId": 2,
    "exceptionType": "java.lang.RuntimeException",
    "exceptionMessage": "exec cat push failed: ",
    "stackTrace": "java.lang.RuntimeException: exec cat push failed: \n    at com.jingbao.store.adb.AdbClient.installApk(AdbClient.kt:252)\n    ...",
    "causedBy": null
  },
  "memoryInfo": {
    "availableMB": 45,
    "totalMB": 128,
    "maxMB": 256
  },
  "additionalInfo": {
    "lastActivity": "MainActivity",
    "usbConnected": true,
    "glassesDeviceModel": "Rokid Max",
    "networkType": "WIFI",
    "batteryLevel": 85,
    "isCharging": false
  }
}
```

### 2. User Feedback Only (No Crash)

```json
{
  "reportType": "user_feedback",
  "feedbackMessage": "建议增加深色模式支持",
  "timestamp": "2026-02-10T22:30:45+08:00",
  "appInfo": {
    "packageName": "com.jingbao.store",
    "versionName": "2.0.3",
    "versionCode": 9
  },
  "deviceInfo": {
    "manufacturer": "vivo",
    "model": "V2339A",
    "brand": "vivo",
    "product": "PD2339",
    "androidVersion": "14",
    "sdkInt": 34,
    "locale": "zh_CN",
    "timezone": "Asia/Shanghai"
  }
}
```

### 3. Automatic Crash Report

```json
{
  "reportType": "crash_report",
  "appInfo": {
    "packageName": "com.jingbao.store",
    "versionName": "2.0.3",
    "versionCode": 9
  },
  "deviceInfo": {
    "manufacturer": "vivo",
    "model": "V2339A",
    "brand": "vivo",
    "product": "PD2339",
    "androidVersion": "14",
    "sdkInt": 34,
    "locale": "zh_CN",
    "timezone": "Asia/Shanghai"
  },
  "crashInfo": {
    "timestamp": "2026-02-10T22:30:45+08:00",
    "timestampMs": 1739196645000,
    "threadName": "main",
    "threadId": 2,
    "exceptionType": "java.lang.RuntimeException",
    "exceptionMessage": "exec cat push failed: ",
    "stackTrace": "java.lang.RuntimeException: exec cat push failed: \n    at com.jingbao.store.adb.AdbClient.installApk(AdbClient.kt:252)\n    ...",
    "causedBy": null
  },
  "memoryInfo": {
    "availableMB": 45,
    "totalMB": 128,
    "maxMB": 256
  }
}
```

## Field Descriptions

### Required Fields

| Field | Type | Description | Required For |
|-------|------|-------------|--------------|
| `reportType` | string | Report type: `crash_report` or `user_feedback` | All reports |
| `appInfo` | object | Application information | All reports |
| `deviceInfo` | object | Device information | All reports |

### Conditional Fields

| Field | Type | Description | Required For |
|-------|------|-------------|--------------|
| `feedbackMessage` | string | User's feedback message | `user_feedback` |
| `crashInfo` | object | Crash details with stack trace | `crash_report` |
| `timestamp` | datetime | Report timestamp | Optional |
| `memoryInfo` | object | Memory usage information | Optional |
| `additionalInfo` | object | Additional context data | Optional |

## Response Format

### Success Response

```json
{
  "success": true,
  "message": "Crash report submitted successfully",
  "id": 123
}
```

**HTTP Status Code**: `201 Created`

### Error Response

```json
{
  "success": false,
  "errors": [
    "Report type can't be blank",
    "Report type is not included in the list"
  ]
}
```

**HTTP Status Code**: `422 Unprocessable Entity`

## Usage Examples

### cURL Example (User Feedback)

```bash
curl -X POST http://localhost:3000/api/crash-report \
  -H "Content-Type: application/json" \
  -H "User-Agent: JingbaoStore/2.0.3 (Android)" \
  -d '{
    "reportType": "user_feedback",
    "feedbackMessage": "应用很好用，但希望增加夜间模式",
    "appInfo": {
      "packageName": "com.jingbao.store",
      "versionName": "2.0.3",
      "versionCode": 9
    },
    "deviceInfo": {
      "manufacturer": "vivo",
      "model": "V2339A",
      "androidVersion": "14",
      "sdkInt": 34
    }
  }'
```

### cURL Example (Crash Report)

```bash
curl -X POST http://localhost:3000/api/crash-report \
  -H "Content-Type: application/json" \
  -d '{
    "reportType": "crash_report",
    "appInfo": {
      "packageName": "com.jingbao.store",
      "versionName": "2.0.3",
      "versionCode": 9
    },
    "deviceInfo": {
      "manufacturer": "vivo",
      "model": "V2339A",
      "androidVersion": "14",
      "sdkInt": 34
    },
    "crashInfo": {
      "timestamp": "2026-02-10T22:30:45+08:00",
      "exceptionType": "java.lang.RuntimeException",
      "exceptionMessage": "exec cat push failed",
      "stackTrace": "java.lang.RuntimeException: exec cat push failed\n    at com.jingbao.store.adb.AdbClient.installApk(AdbClient.kt:252)"
    }
  }'
```

### Android Kotlin Example (User Feedback)

```kotlin
data class UserFeedbackRequest(
    val reportType: String = "user_feedback",
    val feedbackMessage: String,
    val timestamp: String = Instant.now().toString(),
    val appInfo: AppInfo,
    val deviceInfo: DeviceInfo,
    val crashInfo: CrashInfo? = null,
    val memoryInfo: MemoryInfo? = null,
    val additionalInfo: Map<String, Any>? = null
)

suspend fun submitUserFeedback(
    message: String,
    includeCrashInfo: Boolean = false
) {
    val request = UserFeedbackRequest(
        feedbackMessage = message,
        appInfo = AppInfo(
            packageName = context.packageName,
            versionName = BuildConfig.VERSION_NAME,
            versionCode = BuildConfig.VERSION_CODE
        ),
        deviceInfo = DeviceInfo(
            manufacturer = Build.MANUFACTURER,
            model = Build.MODEL,
            androidVersion = Build.VERSION.RELEASE,
            sdkInt = Build.VERSION.SDK_INT
        ),
        crashInfo = if (includeCrashInfo) getCrashInfo() else null
    )
    
    val response = apiClient.post("/api/crash-report") {
        contentType(ContentType.Application.Json)
        setBody(request)
    }
}
```

### Android Kotlin Example (Crash Report)

```kotlin
data class CrashReportRequest(
    val reportType: String = "crash_report",
    val appInfo: AppInfo,
    val deviceInfo: DeviceInfo,
    val crashInfo: CrashInfo,
    val memoryInfo: MemoryInfo? = null,
    val additionalInfo: Map<String, Any>? = null
)

suspend fun submitCrashReport(throwable: Throwable) {
    val request = CrashReportRequest(
        appInfo = AppInfo(
            packageName = context.packageName,
            versionName = BuildConfig.VERSION_NAME,
            versionCode = BuildConfig.VERSION_CODE
        ),
        deviceInfo = DeviceInfo(
            manufacturer = Build.MANUFACTURER,
            model = Build.MODEL,
            brand = Build.BRAND,
            product = Build.PRODUCT,
            androidVersion = Build.VERSION.RELEASE,
            sdkInt = Build.VERSION.SDK_INT,
            locale = Locale.getDefault().toString(),
            timezone = TimeZone.getDefault().id
        ),
        crashInfo = CrashInfo(
            timestamp = Instant.now().toString(),
            timestampMs = System.currentTimeMillis(),
            threadName = Thread.currentThread().name,
            threadId = Thread.currentThread().id,
            exceptionType = throwable.javaClass.name,
            exceptionMessage = throwable.message ?: "",
            stackTrace = throwable.stackTraceToString(),
            causedBy = throwable.cause?.let {
                CausedBy(
                    exceptionType = it.javaClass.name,
                    exceptionMessage = it.message ?: "",
                    stackTrace = it.stackTraceToString()
                )
            }
        ),
        memoryInfo = getMemoryInfo()
    )
    
    val response = apiClient.post("/api/crash-report") {
        contentType(ContentType.Application.Json)
        setBody(request)
    }
}
```

## Admin Backend

Access the crash reports and user feedback in the admin panel:

- **List View**: `/admin/crash_reports` - Browse all reports with filtering by type
- **Detail View**: `/admin/crash_reports/:id` - View complete report details including:
  - Report type badge (User Feedback / Crash Report)
  - User feedback message (if applicable)
  - Full stack traces (if applicable)
  - Device and app information
  - Memory usage data

The admin interface automatically adapts to show relevant sections based on the report type.

## Validation Rules

1. **report_type**: Must be either `crash_report` or `user_feedback`
2. **appInfo**: Required for all report types
3. **deviceInfo**: Required for all report types
4. **feedbackMessage**: Required when `reportType` is `user_feedback`
5. **crashInfo**: Required when `reportType` is `crash_report`

## Notes

- No authentication required for this endpoint
- CSRF protection is disabled for this API
- All JSON keys use camelCase format
- Database stores data with snake_case column names
- The API automatically converts between formats
