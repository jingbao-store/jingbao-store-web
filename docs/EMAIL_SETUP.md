# 邮件配置指南 / Email Setup Guide

本文档说明如何配置邮件发送功能，用于用户注册、密码重置等场景。

This document explains how to configure email sending for user registration, password reset, and other scenarios.

---

## 📧 邮件服务提供商选择 / Email Service Provider Options

### 1. Gmail (推荐用于开发和小规模部署)

**优点：**
- 免费且稳定
- 配置简单
- 适合小规模应用

**缺点：**
- 每日发送限制（免费账户约500封/天）
- 需要开启"应用专用密码"

**配置步骤：**

1. 登录 Gmail 账户
2. 进入"账户设置" → "安全性"
3. 开启"两步验证"
4. 生成"应用专用密码"（App Password）
5. 在 `config/application.yml` 中配置：

```yaml
# Gmail SMTP 配置
SMTP_ADDRESS: "smtp.gmail.com"
SMTP_PORT: "587"
SMTP_DOMAIN: "gmail.com"
SMTP_USERNAME: "your_email@gmail.com"
SMTP_PASSWORD: "your_app_specific_password"  # 使用应用专用密码
SMTP_AUTHENTICATION: "plain"
SMTP_ENABLE_STARTTLS_AUTO: "true"
```

---

### 2. SendGrid (推荐用于生产环境)

**优点：**
- 专业的邮件发送服务
- 免费额度：100封/天（免费计划）
- 提供详细的发送统计和日志
- 高送达率

**缺点：**
- 需要注册账户
- 需要域名验证（提高送达率）

**配置步骤：**

1. 注册 SendGrid 账户：https://sendgrid.com/
2. 创建 API Key：Dashboard → Settings → API Keys
3. 在 `config/application.yml` 中配置：

```yaml
# SendGrid SMTP 配置
SMTP_ADDRESS: "smtp.sendgrid.net"
SMTP_PORT: "587"
SMTP_DOMAIN: "your-domain.com"  # 你的域名
SMTP_USERNAME: "apikey"  # 固定值，不要改
SMTP_PASSWORD: "your_sendgrid_api_key"  # SendGrid API Key
SMTP_AUTHENTICATION: "plain"
SMTP_ENABLE_STARTTLS_AUTO: "true"
```

---

### 3. Amazon SES (推荐用于大规模部署)

**优点：**
- 极低成本（$0.10/千封）
- 高送达率和可靠性
- 与 AWS 服务集成良好

**缺点：**
- 配置相对复杂
- 初始需要申请解除沙盒限制
- 需要 AWS 账户

**配置步骤：**

1. 登录 AWS 控制台
2. 进入 SES 服务
3. 验证发件人邮箱或域名
4. 创建 SMTP 凭证
5. 申请解除沙盒限制（Production Access）
6. 在 `config/application.yml` 中配置：

```yaml
# Amazon SES SMTP 配置
SMTP_ADDRESS: "email-smtp.us-east-1.amazonaws.com"  # 根据你的区域调整
SMTP_PORT: "587"
SMTP_DOMAIN: "your-domain.com"
SMTP_USERNAME: "your_smtp_username"  # SES SMTP 用户名
SMTP_PASSWORD: "your_smtp_password"  # SES SMTP 密码
SMTP_AUTHENTICATION: "login"
SMTP_ENABLE_STARTTLS_AUTO: "true"
```

---

### 4. 腾讯企业邮箱 (适合国内部署)

**优点：**
- 国内访问速度快
- 免费版支持50个账户
- 稳定可靠

**缺点：**
- 需要域名备案
- 需要配置域名解析

**配置步骤：**

1. 注册腾讯企业邮箱：https://exmail.qq.com/
2. 验证域名所有权
3. 创建邮箱账户
4. 在 `config/application.yml` 中配置：

```yaml
# 腾讯企业邮箱 SMTP 配置
SMTP_ADDRESS: "smtp.exmail.qq.com"
SMTP_PORT: "465"
SMTP_DOMAIN: "your-domain.com"
SMTP_USERNAME: "noreply@your-domain.com"
SMTP_PASSWORD: "your_email_password"
SMTP_AUTHENTICATION: "login"
SMTP_ENABLE_STARTTLS_AUTO: "true"
SMTP_TLS: "true"
```

---

### 5. 阿里云邮件推送 (适合国内大规模部署)

**优点：**
- 国内访问速度快
- 价格实惠
- 提供 API 和 SMTP 两种方式

**缺点：**
- 需要实名认证
- 需要域名备案

**配置步骤：**

1. 开通阿里云邮件推送服务
2. 配置发信域名
3. 创建发信地址
4. 在 `config/application.yml` 中配置：

```yaml
# 阿里云邮件推送 SMTP 配置
SMTP_ADDRESS: "smtpdm.aliyun.com"
SMTP_PORT: "465"
SMTP_DOMAIN: "your-domain.com"
SMTP_USERNAME: "noreply@your-domain.com"
SMTP_PASSWORD: "your_smtp_password"
SMTP_AUTHENTICATION: "login"
SMTP_ENABLE_STARTTLS_AUTO: "true"
SMTP_TLS: "true"
```

---

## ⚙️ 配置文件说明 / Configuration Files

### 1. 环境变量配置

编辑 `config/application.yml`（使用 Figaro gem 管理）：

```yaml
# 开发环境
development:
  SMTP_ADDRESS: "smtp.gmail.com"
  SMTP_PORT: "587"
  SMTP_DOMAIN: "gmail.com"
  SMTP_USERNAME: "your_email@gmail.com"
  SMTP_PASSWORD: "your_app_password"
  SMTP_AUTHENTICATION: "plain"
  SMTP_ENABLE_STARTTLS_AUTO: "true"
  DEFAULT_FROM_EMAIL: "noreply@yourdomain.com"
  DEFAULT_FROM_NAME: "镜宝应用商店"

# 生产环境
production:
  SMTP_ADDRESS: "smtp.sendgrid.net"
  SMTP_PORT: "587"
  SMTP_DOMAIN: "yourdomain.com"
  SMTP_USERNAME: "apikey"
  SMTP_PASSWORD: "<%= ENV['SENDGRID_API_KEY'] %>"  # 从系统环境变量读取
  SMTP_AUTHENTICATION: "plain"
  SMTP_ENABLE_STARTTLS_AUTO: "true"
  DEFAULT_FROM_EMAIL: "noreply@yourdomain.com"
  DEFAULT_FROM_NAME: "镜宝应用商店"
```

### 2. Rails 邮件配置

项目已在 `config/environments/production.rb` 和 `config/environments/development.rb` 中配置好 Action Mailer：

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: ENV['SMTP_ADDRESS'],
  port: ENV['SMTP_PORT'],
  domain: ENV['SMTP_DOMAIN'],
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: ENV['SMTP_AUTHENTICATION'] || 'plain',
  enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] == 'true'
}
config.action_mailer.default_url_options = { host: ENV['APP_HOST'] || 'yourdomain.com' }
```

---

## 🧪 测试邮件发送 / Testing Email Delivery

### 1. 在开发环境测试

打开 Rails console：

```bash
rails console
```

发送测试邮件：

```ruby
# 替换为你的邮箱地址
test_email = "your_test_email@example.com"

# 发送测试邮件
UserMailer.with(user: User.first).welcome_email.deliver_now

# 或者创建临时用户测试
user = User.create!(email: test_email, password: "password123", password_confirmation: "password123")
UserMailer.with(user: user).welcome_email.deliver_now
```

### 2. 查看邮件日志

开发环境的邮件会输出到终端日志中。如果配置了真实的 SMTP，检查邮件是否送达。

---

## 🚨 常见问题 / Troubleshooting

### 问题 1: Gmail 显示"登录失败"

**解决方案：**
1. 确保开启了"两步验证"
2. 使用"应用专用密码"而不是账户密码
3. 检查 Gmail 的"允许不够安全的应用访问"设置

### 问题 2: 邮件进入垃圾箱

**解决方案：**
1. 配置 SPF、DKIM、DMARC 记录
2. 使用真实的域名邮箱作为发件人
3. 避免在邮件内容中使用垃圾邮件常见词汇
4. 使用专业的邮件服务（SendGrid、SES 等）

### 问题 3: 邮件发送失败

**排查步骤：**
1. 检查 SMTP 配置是否正确
2. 检查网络连接和防火墙设置
3. 查看 Rails 日志：`tail -f log/production.log`
4. 测试 SMTP 连接：
   ```bash
   telnet smtp.gmail.com 587
   ```

### 问题 4: 生产环境邮件不发送

**解决方案：**
1. 确认环境变量在生产服务器上正确设置
2. 检查 `config/environments/production.rb` 的邮件配置
3. 确保生产服务器能访问 SMTP 服务器（检查防火墙）
4. 查看 ActionMailer 队列（如果使用了 ActiveJob）

---

## 📝 生产环境部署清单 / Production Deployment Checklist

- [ ] 选择并注册邮件服务提供商
- [ ] 配置环境变量（`config/application.yml` 或系统环境变量）
- [ ] 配置域名的 SPF、DKIM 记录（提高送达率）
- [ ] 设置 `DEFAULT_FROM_EMAIL` 和 `APP_HOST`
- [ ] 测试邮件发送功能
- [ ] 监控邮件发送日志和送达率
- [ ] 配置邮件模板（可选）

---

## 🔒 安全建议 / Security Best Practices

1. **不要将密码提交到代码仓库**
   - 使用 `config/application.yml` (已添加到 .gitignore)
   - 或使用系统环境变量

2. **使用应用专用密码**
   - Gmail、Outlook 等个人邮箱要使用应用专用密码
   - 不要使用主账户密码

3. **限制发送频率**
   - 防止被滥用发送垃圾邮件
   - 使用 rate limiting 限制注册和密码重置频率

4. **定期轮换密钥**
   - 定期更新 SMTP 密码和 API Key
   - 使用密钥管理服务（如 AWS Secrets Manager）

---

## 📚 相关资源 / Additional Resources

- [Action Mailer 官方文档](https://guides.rubyonrails.org/action_mailer_basics.html)
- [SendGrid SMTP 文档](https://docs.sendgrid.com/for-developers/sending-email/getting-started-smtp)
- [Amazon SES 文档](https://docs.aws.amazon.com/ses/)
- [Gmail SMTP 设置](https://support.google.com/mail/answer/7126229)

---

## 💬 技术支持 / Support

如有问题，请：
1. 查看本文档的常见问题部分
2. 检查 Rails 日志文件
3. 参考邮件服务商的官方文档
4. 提交 Issue 到项目仓库

---

**最后更新：** 2025-01-13
