# APK 上传功能测试指南

## 测试准备

1. 确保 Rails 应用正在运行
2. 确保已有管理员账号
3. 准备一个测试 APK 文件（或使用任意 APK 文件进行测试）

## 测试步骤

### 测试一：上传 APK 文件创建应用

1. 访问 `/admin` 登录管理后台
2. 点击左侧菜单的 "Applications"
3. 点击 "New Application" 按钮
4. 填写基本信息：
   - Name: `测试应用 1`
   - Package name: `com.test.app1`
   - Version: `1.0.0`
   - Description: `这是一个测试应用`
   - Category: 选择任意分类
   - Downloads: `0`
5. 在"下载来源"部分，选择"方式一：上传 APK 文件"
6. 点击文件选择按钮，选择一个 APK 文件
7. 注意：无需填写 File size 和 File size bytes（会自动计算）
8. 点击 "Create Application" 保存

**预期结果：**
- ✅ 应用创建成功
- ✅ 文件大小自动填写
- ✅ 在详情页看到"使用上传的 APK 文件"标识
- ✅ 显示文件名和大小

### 测试二：使用外部链接创建应用

1. 访问 `/admin/applications/new`
2. 填写基本信息：
   - Name: `测试应用 2`
   - Package name: `com.test.app2`
   - Version: `1.0.0`
   - Description: `使用外部链接的测试应用`
   - Category: 选择任意分类
   - Downloads: `0`
3. 在"下载来源"部分，选择"方式二：下载链接"
4. 填写一个外部 APK 链接（例如：`https://example.com/test.apk`）
5. 手动填写文件大小信息：
   - File size: `10 MB`
   - File size bytes: `10485760`
6. 点击 "Create Application" 保存

**预期结果：**
- ✅ 应用创建成功
- ✅ 在详情页看到"使用外部下载链接"标识
- ✅ 显示外部链接

### 测试三：验证必须提供下载来源

1. 访问 `/admin/applications/new`
2. 填写基本信息（但不提供 APK 文件也不填写下载链接）
3. 点击 "Create Application"

**预期结果：**
- ❌ 创建失败
- ✅ 显示错误信息："必须提供 APK 文件或下载 URL 其中之一"

### 测试四：编辑应用 - 更新 APK 文件

1. 找到之前创建的应用（使用外部链接的那个）
2. 点击 "Edit" 按钮
3. 在"方式一：上传 APK 文件"中选择一个新的 APK 文件
4. 保持原有的外部链接不变
5. 点击 "Update Application"

**预期结果：**
- ✅ 更新成功
- ✅ 现在优先使用上传的 APK 文件
- ✅ 外部链接作为"备用链接"显示

### 测试五：API 响应测试

#### 测试上传 APK 的应用

打开终端，执行：

```bash
curl http://localhost:3000/api/v1/applications/1 | jq
```

**预期结果：**
```json
{
  "download_url": "http://localhost:3000/rails/active_storage/blobs/.../xxx.apk",
  "file_size": "13 MB",
  "file_size_bytes": 13631488
}
```

#### 测试使用外部链接的应用

```bash
curl http://localhost:3000/api/v1/applications/2 | jq
```

**预期结果：**
```json
{
  "download_url": "https://example.com/test.apk",
  "file_size": "10 MB",
  "file_size_bytes": 10485760
}
```

### 测试六：下载功能测试

1. 访问应用详情页
2. 点击 "Download URL" 链接
3. 验证文件能否正常下载

**预期结果：**
- ✅ 如果是上传的 APK，应该从服务器下载
- ✅ 如果是外部链接，应该重定向到外部地址

### 测试七：列表页面测试

1. 访问 `/admin/applications`
2. 查看应用列表

**预期结果：**
- ✅ 所有应用正常显示
- ✅ 没有明显的性能问题

## 边界情况测试

### 测试 8：大文件上传

1. 尝试上传一个较大的 APK 文件（例如 100MB+）
2. 观察上传过程

**注意事项：**
- 可能需要配置服务器的上传大小限制
- 参考 `config/application.rb` 或 nginx/apache 配置

### 测试 9：同时提供两种方式

1. 创建应用时，同时上传 APK 文件和填写外部链接
2. 保存并查看详情

**预期结果：**
- ✅ 优先使用 APK 文件
- ✅ 外部链接显示为"备用链接"

### 测试 10：删除 APK 文件

1. 编辑一个使用 APK 文件的应用
2. 清空 APK 文件选择
3. 确保有外部链接
4. 保存

**预期结果：**
- ✅ 应该切换到使用外部链接
- ✅ 或者显示验证错误（如果两者都为空）

## API 集成测试

### 测试客户端集成

使用镜宝 Android 客户端测试：

1. 启动 Android 应用
2. 浏览应用列表
3. 尝试下载一个使用上传 APK 的应用
4. 尝试下载一个使用外部链接的应用

**预期结果：**
- ✅ 两种方式都能正常下载
- ✅ 客户端无需感知区别

## 回滚测试

### 测试现有应用的兼容性

1. 检查迁移前创建的应用
2. 确保它们仍然能正常工作
3. API 返回的 download_url 应该是数据库中的值

**预期结果：**
- ✅ 现有应用不受影响
- ✅ API 响应保持一致

## 性能测试

### 测试大量应用

1. 创建 50+ 个应用（包含 APK 上传）
2. 访问列表页面
3. 测试 API 响应时间

**预期结果：**
- ✅ 列表加载时间合理
- ✅ API 响应时间 < 500ms

## 问题排查

### 常见问题

#### 问题 1：文件上传失败

**检查：**
- Rails 日志中的错误信息
- 服务器磁盘空间
- 文件权限

#### 问题 2：文件大小未自动计算

**检查：**
- 控制器中的 `update_file_size_from_apk` 调用
- 模型中的方法实现

#### 问题 3：API 返回的 download_url 为空

**检查：**
- `final_download_url` 方法实现
- ActiveStorage 配置
- URL helpers 配置

## 清理测试数据

测试完成后：

```bash
# Rails console
rails console

# 删除测试应用
Application.where("name LIKE 'Test%'").destroy_all

# 或者重置数据库（谨慎！）
# rails db:reset
```

## 报告问题

如果发现问题，请提供以下信息：

1. 问题描述
2. 复现步骤
3. 预期结果 vs 实际结果
4. Rails 日志
5. 浏览器控制台错误（如果有）
6. 截图

## 测试清单

- [ ] 测试一：上传 APK 创建应用
- [ ] 测试二：外部链接创建应用
- [ ] 测试三：验证必须提供下载来源
- [ ] 测试四：更新 APK 文件
- [ ] 测试五：API 响应测试
- [ ] 测试六：下载功能测试
- [ ] 测试七：列表页面测试
- [ ] 测试八：大文件上传
- [ ] 测试九：同时提供两种方式
- [ ] 测试十：删除 APK 文件
- [ ] API 集成测试
- [ ] 回滚测试
- [ ] 性能测试

---

测试愉快！🎉

