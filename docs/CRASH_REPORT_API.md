# Crash Report API Documentation

## Overview
The Crash Report API allows applications to submit crash reports for debugging and monitoring purposes.

## Endpoint

### Submit Crash Report

**POST** `/api/crash-report`

Submit a new crash report to the system.

#### Request Headers
```
Content-Type: application/json
```

#### Request Body

```json
{
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
    "stackTrace": "java.lang.RuntimeException: exec cat push failed\n    at com.example.Test.main(Test.java:10)"
  },
  "memoryInfo": {
    "availableMB": 45,
    "totalMB": 128
  },
  "additionalInfo": {
    "usbConnected": true,
    "glassesDeviceModel": "Rokid Max"
  }
}
```

#### Field Descriptions

##### appInfo (required)
- `packageName` (string): Application package name
- `versionName` (string): Human-readable version name
- `versionCode` (number): Internal version code

##### deviceInfo (required)
- `manufacturer` (string): Device manufacturer
- `model` (string): Device model
- `androidVersion` (string): Android OS version
- `sdkInt` (number): Android SDK API level

##### crashInfo (required)
- `timestamp` (string): ISO 8601 timestamp when crash occurred
- `exceptionType` (string): Full class name of the exception
- `exceptionMessage` (string): Exception message
- `stackTrace` (string): Complete stack trace

##### memoryInfo (optional)
- `availableMB` (number): Available memory in MB
- `totalMB` (number): Total device memory in MB

##### additionalInfo (optional)
- Any additional key-value pairs relevant to the crash

#### Success Response

**Status Code:** `201 Created`

```json
{
  "success": true,
  "message": "Crash report submitted successfully",
  "id": 5
}
```

#### Error Response

**Status Code:** `422 Unprocessable Entity`

```json
{
  "success": false,
  "errors": [
    "App info can't be blank",
    "Device info can't be blank",
    "Crash info can't be blank"
  ]
}
```

## Example Usage

### Using cURL

```bash
curl -X POST http://your-server.com/api/crash-report \
  -H 'Content-Type: application/json' \
  -d '{
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
      "stackTrace": "java.lang.RuntimeException: exec cat push failed\n    at com.example.Test.main(Test.java:10)"
    },
    "memoryInfo": {
      "availableMB": 45,
      "totalMB": 128
    },
    "additionalInfo": {
      "usbConnected": true,
      "glassesDeviceModel": "Rokid Max"
    }
  }'
```

### Using Android (Kotlin)

```kotlin
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject

fun submitCrashReport(
    packageName: String,
    versionName: String,
    versionCode: Int,
    manufacturer: String,
    model: String,
    androidVersion: String,
    sdkInt: Int,
    exceptionType: String,
    exceptionMessage: String,
    stackTrace: String
) {
    val client = OkHttpClient()
    
    val json = JSONObject().apply {
        put("appInfo", JSONObject().apply {
            put("packageName", packageName)
            put("versionName", versionName)
            put("versionCode", versionCode)
        })
        put("deviceInfo", JSONObject().apply {
            put("manufacturer", manufacturer)
            put("model", model)
            put("androidVersion", androidVersion)
            put("sdkInt", sdkInt)
        })
        put("crashInfo", JSONObject().apply {
            put("timestamp", System.currentTimeMillis().toString())
            put("exceptionType", exceptionType)
            put("exceptionMessage", exceptionMessage)
            put("stackTrace", stackTrace)
        })
        put("memoryInfo", JSONObject().apply {
            val runtime = Runtime.getRuntime()
            put("availableMB", runtime.freeMemory() / 1024 / 1024)
            put("totalMB", runtime.totalMemory() / 1024 / 1024)
        })
        put("additionalInfo", JSONObject())
    }
    
    val mediaType = "application/json; charset=utf-8".toMediaType()
    val body = json.toString().toRequestBody(mediaType)
    
    val request = Request.Builder()
        .url("http://your-server.com/api/crash-report")
        .post(body)
        .build()
    
    client.newCall(request).execute()
}
```

## Admin Dashboard

Submitted crash reports can be viewed and managed in the admin dashboard at:

`/admin/crash_reports`

The dashboard provides:
- List view of all crash reports with filtering
- Detailed view showing complete crash information including stack traces
- Ability to delete crash reports

## Notes

- No authentication is required for submitting crash reports
- CSRF protection is disabled for this endpoint
- All timestamps should be in ISO 8601 format
- Stack traces should preserve newline characters for proper formatting
