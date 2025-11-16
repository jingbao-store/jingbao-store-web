# APK 上传功能说明

## 功能概述

镜宝应用商店后台现已支持两种方式提供应用下载：

1. **上传 APK 文件**（推荐）- 直接上传 APK 文件到服务器
2. **提供下载 URL** - 提供外部托管的 APK 下载链接

管理员在创建或编辑应用时，可以二选一或两者都提供，系统会优先使用上传的 APK 文件。

## 功能特性

### 1. APK 文件上传
- ✅ 支持直接上传 `.apk` 文件
- ✅ 自动计算文件大小（无需手动填写）
- ✅ 使用 Rails ActiveStorage 托管文件
- ✅ 自动生成下载 URL

### 2. 外部下载链接
- ✅ 保留原有的 `download_url` 字段
- ✅ 支持提供外部托管的 APK 链接
- ✅ 灵活适应不同的托管方案

### 3. 智能选择
- ✅ API 自动返回最合适的下载 URL
- ✅ 优先级：上传的 APK > 外部链接
- ✅ 对客户端透明，无需修改 API 调用

### 4. 验证规则
- ✅ 至少提供一种下载方式（APK 文件或 URL）
- ✅ 如果两者都提供，优先使用 APK 文件
- ✅ 友好的错误提示

## 实现细节

### 数据模型 (`app/models/application.rb`)

```ruby
# 添加 APK 文件附件
has_one_attached :apk_file

# 验证：必须有下载来源
validate :must_have_download_source

# 返回最终的下载 URL
def final_download_url
  if apk_file.attached?
    Rails.application.routes.url_helpers.rails_blob_url(apk_file, only_path: false)
  else
    download_url
  end
end

# 自动计算文件大小
def update_file_size_from_apk
  return unless apk_file.attached?
  
  self.file_size_bytes = apk_file.byte_size
  self.file_size = format_file_size(file_size_bytes)
end
```

### 管理界面

#### 新建应用表单 (`app/views/admin/applications/new.html.erb`)
- 明确标注两种下载方式
- 视觉上用边框区分两个选项
- 显示 "或 (OR)" 分隔符
- 提示自动计算文件大小

#### 编辑应用表单 (`app/views/admin/applications/edit.html.erb`)
- 显示当前使用的方式
- 如果已上传 APK，显示文件名和大小
- 如果使用外部链接，显示当前链接

### API 端点

#### GET `/api/v1/applications`
- 返回所有应用列表
- `download_url` 字段自动使用 `final_download_url` 方法

#### GET `/api/v1/applications/:id`
- 返回单个应用详情
- `download_url` 字段自动使用 `final_download_url` 方法

## 使用指南

### 管理员操作步骤

#### 方式一：上传 APK 文件（推荐）

1. 访问管理后台 `/admin/applications/new` 或 `/admin/applications/:id/edit`
2. 在"下载来源"部分，选择"方式一：上传 APK 文件"
3. 点击文件选择按钮，选择本地 APK 文件
4. 系统会自动计算并填写文件大小
5. 保存应用

**优点**：
- 文件托管在自己的服务器上
- 下载速度可控
- 不依赖外部服务
- 文件大小自动计算

#### 方式二：提供下载 URL

1. 访问管理后台 `/admin/applications/new` 或 `/admin/applications/:id/edit`
2. 在"下载来源"部分，选择"方式二：下载链接"
3. 输入外部 APK 托管地址（如 GitHub Releases）
4. 手动填写文件大小信息
5. 保存应用

**优点**：
- 适合已有外部托管方案
- 节省服务器存储空间
- 可以使用 CDN 加速

#### 方式三：两者都提供

1. 同时上传 APK 文件和填写外部链接
2. 系统会优先使用上传的 APK 文件
3. 作为备份方案，可以手动切换

## 技术规格

### 存储配置

使用 Rails ActiveStorage 进行文件管理：

```ruby
# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>
```

### 文件大小格式化

自动转换为人类可读格式：
- 1024 B → 1 KB
- 1048576 B → 1 MB
- 1073741824 B → 1 GB

### URL 生成

- **上传文件**: `/rails/active_storage/blobs/:signed_id/:filename`
- **外部链接**: 直接使用提供的 URL

## API 响应示例

### 使用上传 APK 的应用

```json
{
  "id": 1,
  "name": "小蜜蜂游戏",
  "download_url": "https://yourdomain.com/rails/active_storage/blobs/xxx/bee-game.apk",
  "file_size": "13 MB",
  "file_size_bytes": 13631488
}
```

### 使用外部链接的应用

```json
{
  "id": 2,
  "name": "示例应用",
  "download_url": "https://github.com/example/releases/download/v1.0.0/app.apk",
  "file_size": "5 MB",
  "file_size_bytes": 5242880
}
```

## 注意事项

1. **存储空间**: 上传 APK 会占用服务器存储空间，请根据实际情况规划
2. **文件大小限制**: 可能需要配置 Rails 和 Web 服务器的文件上传大小限制
3. **备份**: 建议定期备份 `storage/` 目录
4. **CDN**: 可以配置 ActiveStorage 使用 AWS S3 或其他云存储服务
5. **带宽**: 如果应用较大且下载量大，建议使用 CDN 或外部托管

## 迁移建议

对于现有应用：

1. 现有的外部链接继续有效，无需修改
2. 可以逐步将重要应用的 APK 上传到服务器
3. API 响应格式保持不变，客户端无需更新

## 未来扩展

可能的功能增强：

- [ ] 支持多个 APK 版本管理
- [ ] APK 自动签名验证
- [ ] 从 APK 中自动提取应用信息（包名、版本等）
- [ ] 下载统计和分析
- [ ] 自动病毒扫描
- [ ] APK 差分更新支持

## 相关文件

- 模型: `app/models/application.rb`
- 管理控制器: `app/controllers/admin/applications_controller.rb`
- API 控制器: `app/controllers/api/v1/applications_controller.rb`
- 新建视图: `app/views/admin/applications/new.html.erb`
- 编辑视图: `app/views/admin/applications/edit.html.erb`
- API 文档: `API.md`

## 支持

如有问题，请联系开发团队。

