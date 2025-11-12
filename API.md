# 镜宝应用商店 API 文档

## 基础信息

- **Base URL**: `https://your-domain.com/api/v1` 或本地开发 `http://localhost:3000/api/v1`
- **数据格式**: JSON
- **字符编码**: UTF-8
- **认证方式**: 无需认证（公开只读 API）

---

## API 端点列表

### 1. 获取所有分类及应用

获取所有应用分类，包含每个分类下的应用列表。

**请求**

```http
GET /api/v1/categories
```

**响应示例**

```json
[
  {
    "id": 1,
    "name": "游戏娱乐",
    "slug": "44f87bd8-5386-4e44-a5f1-bb1fd6dbd6f5",
    "icon": "🎮",
    "description": "适配智能眼镜的游戏应用，提供沉浸式游戏体验",
    "display_order": 1,
    "applications": [
      {
        "id": 1,
        "name": "小蜜蜂游戏",
        "package_name": "com.rokid.bee.game",
        "version": "1.0.0",
        "icon": "🐝",
        "download_url": "https://github.com/jingbao-store/releases/download/v1.0.0/bee-game.apk",
        "file_size": "13 MB",
        "file_size_bytes": 13631488,
        "rating": "4.5",
        "downloads": 1250
      }
    ]
  },
  {
    "id": 6,
    "name": "手机应用",
    "slug": "shou-ji-ying-yong",
    "icon": "📱",
    "description": "可与眼镜搭配使用的手机应用，如蓝牙键盘、虚拟鼠标等配件类应用",
    "display_order": 6,
    "applications": [
      {
        "id": 4,
        "name": "蓝牙键盘",
        "package_name": "io.appground.blek",
        "version": "3.2.1",
        "icon": "⌨️",
        "download_url": "https://play.google.com/store/apps/details?id=io.appground.blek",
        "file_size": "8 MB",
        "file_size_bytes": 8388608,
        "rating": "4.7",
        "downloads": 8920
      }
    ]
  }
]
```

**字段说明**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | integer | 分类唯一标识 |
| name | string | 分类名称 |
| slug | string | 分类 slug（用于 URL） |
| icon | string | 分类图标（emoji） |
| description | string | 分类描述 |
| display_order | integer | 显示顺序 |
| applications | array | 该分类下的应用列表 |

---

### 2. 获取单个分类详情

获取指定分类的详细信息及其应用列表。

**请求**

```http
GET /api/v1/categories/:id
```

**参数**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | integer | 是 | 分类 ID |

**请求示例**

```bash
curl http://localhost:3000/api/v1/categories/1
```

**响应示例**

```json
{
  "id": 1,
  "name": "游戏娱乐",
  "slug": "44f87bd8-5386-4e44-a5f1-bb1fd6dbd6f5",
  "icon": "🎮",
  "description": "适配智能眼镜的游戏应用，提供沉浸式游戏体验",
  "display_order": 1,
  "applications": [
    {
      "id": 1,
      "name": "小蜜蜂游戏",
      "package_name": "com.rokid.bee.game",
      "version": "1.0.0",
      "description": "经典的小蜜蜂射击游戏，完美适配智能眼镜...",
      "icon": "🐝",
      "download_url": "https://github.com/jingbao-store/releases/download/v1.0.0/bee-game.apk",
      "file_size": "13 MB",
      "file_size_bytes": 13631488,
      "developer": "Rokid",
      "rating": "4.5",
      "downloads": 1250,
      "last_updated": "2025-10-28",
      "min_android_version": "8.0",
      "permissions_array": ["网络访问", "存储权限"],
      "features_array": ["手势控制", "语音操作", "多关卡挑战"]
    }
  ]
}
```

---

### 3. 获取所有应用列表

获取所有应用的列表（不包含分类嵌套）。

**请求**

```http
GET /api/v1/applications
```

**响应示例**

```json
[
  {
    "id": 1,
    "name": "小蜜蜂游戏",
    "package_name": "com.rokid.bee.game",
    "version": "1.0.0",
    "description": "经典的小蜜蜂射击游戏，完美适配智能眼镜...",
    "icon": "🐝",
    "download_url": "https://github.com/jingbao-store/releases/download/v1.0.0/bee-game.apk",
    "file_size": "13 MB",
    "file_size_bytes": 13631488,
    "developer": "Rokid",
    "rating": "4.5",
    "downloads": 1250,
    "last_updated": "2025-10-28",
    "min_android_version": "8.0",
    "permissions_array": ["网络访问", "存储权限"],
    "features_array": ["手势控制", "语音操作", "多关卡挑战"],
    "category": {
      "id": 1,
      "name": "游戏娱乐",
      "icon": "🎮"
    }
  }
]
```

**字段说明**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | integer | 应用唯一标识 |
| name | string | 应用名称 |
| package_name | string | 应用包名 |
| version | string | 版本号 |
| description | string | 应用描述 |
| icon | string | 应用图标（emoji） |
| download_url | string | APK 下载链接 |
| file_size | string | 文件大小（易读格式） |
| file_size_bytes | integer | 文件大小（字节） |
| developer | string | 开发者 |
| rating | decimal | 评分（0-5） |
| downloads | integer | 下载次数 |
| last_updated | date | 最后更新日期 |
| min_android_version | string | 最低安卓版本 |
| permissions_array | array | 权限列表 |
| features_array | array | 功能特性列表 |
| category | object | 所属分类信息 |

---

### 4. 获取单个应用详情

获取指定应用的详细信息。

**请求**

```http
GET /api/v1/applications/:id
```

**参数**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | integer | 是 | 应用 ID |

**请求示例**

```bash
curl http://localhost:3000/api/v1/applications/1
```

**响应示例**

```json
{
  "id": 1,
  "name": "小蜜蜂游戏",
  "package_name": "com.rokid.bee.game",
  "version": "1.0.0",
  "description": "经典的小蜜蜂射击游戏，完美适配智能眼镜，支持手势控制和语音操作。体验复古游戏的乐趣，享受全新的AR游戏体验。",
  "icon": "🐝",
  "download_url": "https://github.com/jingbao-store/releases/download/v1.0.0/bee-game.apk",
  "file_size": "13 MB",
  "file_size_bytes": 13631488,
  "developer": "Rokid",
  "rating": "4.5",
  "downloads": 1250,
  "last_updated": "2025-10-28",
  "min_android_version": "8.0",
  "permissions_array": ["网络访问", "存储权限"],
  "features_array": ["手势控制", "语音操作", "多关卡挑战"],
  "category": {
    "id": 1,
    "name": "游戏娱乐",
    "icon": "🎮"
  }
}
```

---

## 错误响应

当请求失败时，API 会返回相应的 HTTP 状态码和错误信息。

**404 Not Found**

```json
{
  "error": "Record not found"
}
```

**500 Internal Server Error**

```json
{
  "error": "Internal server error"
}
```

---

## 使用示例

### cURL 示例

```bash
# 获取所有分类
curl http://localhost:3000/api/v1/categories

# 获取特定分类
curl http://localhost:3000/api/v1/categories/6

# 获取所有应用
curl http://localhost:3000/api/v1/applications

# 获取特定应用
curl http://localhost:3000/api/v1/applications/4
```

### Android/Kotlin 示例

```kotlin
import okhttp3.*
import org.json.JSONArray
import java.io.IOException

class JingBaoApiClient {
    private val client = OkHttpClient()
    private val baseUrl = "https://your-domain.com/api/v1"
    
    fun getCategories(callback: (JSONArray?) -> Unit) {
        val request = Request.Builder()
            .url("$baseUrl/categories")
            .build()
        
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                callback(null)
            }
            
            override fun onResponse(call: Call, response: Response) {
                response.body?.string()?.let {
                    callback(JSONArray(it))
                }
            }
        })
    }
    
    fun getApplications(callback: (JSONArray?) -> Unit) {
        val request = Request.Builder()
            .url("$baseUrl/applications")
            .build()
        
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                callback(null)
            }
            
            override fun onResponse(call: Call, response: Response) {
                response.body?.string()?.let {
                    callback(JSONArray(it))
                }
            }
        })
    }
}
```

### JavaScript/Fetch 示例

```javascript
// 获取所有分类
async function getCategories() {
  const response = await fetch('http://localhost:3000/api/v1/categories');
  const categories = await response.json();
  return categories;
}

// 获取所有应用
async function getApplications() {
  const response = await fetch('http://localhost:3000/api/v1/applications');
  const applications = await response.json();
  return applications;
}

// 获取特定应用详情
async function getApplication(id) {
  const response = await fetch(`http://localhost:3000/api/v1/applications/${id}`);
  const application = await response.json();
  return application;
}
```

---

## 注意事项

1. **编码**: 所有 API 返回的中文内容已正确编码为 UTF-8
2. **频率限制**: 目前无频率限制，建议合理使用
3. **CORS**: 如果需要从浏览器直接调用，需要配置 CORS
4. **认证**: 当前 API 为公开只读接口，无需认证
5. **版本**: 当前 API 版本为 v1，未来可能增加新版本

---

## 数据更新

- 应用数据通过管理后台实时更新
- API 返回的是实时数据，无缓存
- 建议客户端根据需要实现缓存机制

---

## 支持与反馈

如有问题或建议，请通过以下方式联系：

- GitHub Issues: https://github.com/jingbao-store/web/issues
- 邮箱: support@jingbao.app（示例）
