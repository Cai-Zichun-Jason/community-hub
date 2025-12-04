# BookStack 使用指南

## BookStack 访问说明

### 为什么直接跳转到登录页面？

BookStack 默认配置为**私有模式**，这是出于安全考虑：

1. **保护内容隐私**：防止未授权用户查看文档内容
2. **企业级安全**：适合内部知识库和敏感文档管理
3. **访问控制**：确保只有授权用户才能访问

### 如何允许游客访问？

如果希望允许未登录用户浏览内容，需要修改设置：

1. **以管理员身份登录**
2. **进入设置页面**：点击右上角头像 → Settings
3. **修改访问权限**：
   - 找到 "Registration Settings"
   - 启用 "Allow public viewing" 或 "Enable public access"
   - 设置 "Public Role" 为 "Viewer"（只读权限）

4. **保存设置**

修改后，未登录用户可以浏览公开内容，但仍需登录才能编辑。

## 默认管理员账号

### 首次安装的默认账号

BookStack 首次安装时会创建默认管理员账号：

```
邮箱：admin@admin.com
密码：password
```

### 重要：首次登录后必须修改

1. **登录后立即修改密码**：
   - 点击右上角头像
   - 选择 "Edit Profile"
   - 修改密码

2. **修改管理员邮箱**：
   - 在 "Edit Profile" 页面
   - 修改 Email 为你的实际邮箱

3. **建议修改用户名**：
   - 将 "admin" 改为其他用户名
   - 提高安全性

### 如果忘记密码

可以通过命令行重置管理员密码：

```bash
# 进入 BookStack 容器
docker compose exec bookstack bash

# 重置管理员密码
php artisan bookstack:reset-password admin@admin.com

# 按提示输入新密码
```

或者使用环境变量创建新管理员：

```bash
# 在 docker-compose.yml 中添加
bookstack:
  environment:
    - ADMIN_EMAIL=your@email.com
    - ADMIN_PASSWORD=YourSecurePassword
    - ADMIN_NAME=YourName
```

## 用户注册设置

### 为什么不能注册？

BookStack 默认**关闭公开注册**，防止未授权用户自行注册。

### 如何开启用户注册？

**方法 1：通过管理界面开启**

1. 以管理员身份登录
2. 进入 Settings → Registration Settings
3. 启用 "Allow Registration"
4. 选择注册方式：
   - **Open Registration**：任何人都可以注册
   - **Require Email Confirmation**：需要邮箱验证
   - **Restrict Registration**：限制特定域名邮箱注册

**方法 2：通过环境变量开启**

在 `docker-compose.yml` 中添加：

```yaml
bookstack:
  environment:
    - ALLOW_REGISTRATION=true
    - ALLOW_CONTENT_SCRIPTS=false  # 安全考虑，禁用脚本
```

### 推荐的注册策略

**小型团队（推荐）**：

```yaml
# 关闭公开注册，由管理员手动创建用户
- ALLOW_REGISTRATION=false
```

管理员手动添加用户：
1. Settings → Users
2. 点击 "Create New User"
3. 填写用户信息并分配角色

**中型团队**：

```yaml
# 开启注册，但限制邮箱域名
- ALLOW_REGISTRATION=true
- ALLOWED_EMAIL_DOMAINS=company.com,example.com
```

**公开社区**：

```yaml
# 开启公开注册，启用邮箱验证
- ALLOW_REGISTRATION=true
- REQUIRE_EMAIL_CONFIRMATION=true
```

## 用户角色与权限

BookStack 有四种默认角色：

### 1. Admin（管理员）
- 完全控制权限
- 可以管理用户、角色、设置
- 可以访问和编辑所有内容

### 2. Editor（编辑者）
- 可以创建和编辑内容
- 可以管理自己创建的书籍和页面
- 不能访问系统设置

### 3. Viewer（查看者）
- 只能查看内容
- 不能创建或编辑
- 适合只读用户

### 4. Public（公开角色）
- 未登录用户的默认角色
- 默认无权限
- 可以配置为允许查看公开内容

### 自定义角色

管理员可以创建自定义角色：

1. Settings → Roles
2. 点击 "Create New Role"
3. 设置权限：
   - Content Permissions（内容权限）
   - System Permissions（系统权限）
   - Asset Permissions（资源权限）

## 常用配置

### 1. 配置邮件服务

在 `docker-compose.yml` 中添加：

```yaml
bookstack:
  environment:
    # SMTP 配置
    - MAIL_DRIVER=smtp
    - MAIL_HOST=smtp.gmail.com
    - MAIL_PORT=587
    - MAIL_USERNAME=your@gmail.com
    - MAIL_PASSWORD=your-app-password
    - MAIL_ENCRYPTION=tls
    - MAIL_FROM=your@gmail.com
    - MAIL_FROM_NAME=BookStack
```

### 2. 配置文件上传

```yaml
bookstack:
  environment:
    # 上传限制（MB）
    - FILE_UPLOAD_SIZE_LIMIT=50
    - ALLOWED_FILE_TYPES=jpg,jpeg,png,gif,pdf,txt,doc,docx,xls,xlsx
```

### 3. 配置语言

```yaml
bookstack:
  environment:
    - APP_LANG=zh_CN  # 中文
    # - APP_LANG=en    # 英文
```

### 4. 配置时区

```yaml
bookstack:
  environment:
    - TZ=Asia/Shanghai
    - APP_TIMEZONE=Asia/Shanghai
```

## 数据备份

### 备份数据库

```bash
# 导出 BookStack 数据库
docker compose exec mysql mysqldump -u bookstack -p bookstack > bookstack_backup_$(date +%Y%m%d).sql

# 输入密码（在 .env 文件中的 MYSQL_BOOKSTACK_PASSWORD）
```

### 备份上传文件

```bash
# 备份 BookStack 配置和上传文件
tar -czf bookstack_files_$(date +%Y%m%d).tar.gz ./bookstack/config/
```

### 恢复备份

```bash
# 恢复数据库
docker compose exec -T mysql mysql -u bookstack -p bookstack < bookstack_backup_20251205.sql

# 恢复文件
tar -xzf bookstack_files_20251205.tar.gz
```

## 常见问题

### Q1: 如何修改网站名称和 Logo？

1. 登录管理员账号
2. Settings → Customization
3. 修改：
   - Application Name（应用名称）
   - Application Logo（上传 Logo）
   - Application Icon（上传图标）

### Q2: 如何启用 LDAP/SAML 认证？

在 `docker-compose.yml` 中配置：

```yaml
bookstack:
  environment:
    # LDAP 认证
    - AUTH_METHOD=ldap
    - LDAP_SERVER=ldap.example.com
    - LDAP_BASE_DN=dc=example,dc=com
    - LDAP_DN=cn=admin,dc=example,dc=com
    - LDAP_PASS=admin_password
```

### Q3: 如何导入/导出内容？

**导出**：
1. 打开要导出的书籍
2. 点击右上角 "..." 菜单
3. 选择 "Export" → 选择格式（PDF、HTML、Markdown、Plain Text）

**导入**：
- BookStack 不支持直接导入
- 可以通过 API 批量创建内容
- 或手动复制粘贴 Markdown 内容

### Q4: 如何设置书籍/页面权限？

1. 打开书籍或页面
2. 点击 "Permissions" 按钮
3. 设置：
   - **Inherit Permissions**：继承父级权限
   - **Custom Permissions**：自定义权限
   - 为不同角色设置 View/Create/Update/Delete 权限

### Q5: 如何启用 Markdown 编辑器？

BookStack 支持两种编辑器：

1. Settings → Preferences
2. 选择 "Default Editor"：
   - **WYSIWYG**：所见即所得（默认）
   - **Markdown**：Markdown 编辑器

每个用户可以在个人设置中选择自己喜欢的编辑器。

## 安全建议

1. **修改默认管理员账号**
   - 立即修改密码
   - 修改邮箱地址
   - 考虑修改用户名

2. **限制注册**
   - 关闭公开注册或限制邮箱域名
   - 启用邮箱验证

3. **配置 HTTPS**
   - 使用 Nginx 反向代理配置 SSL
   - 强制 HTTPS 访问

4. **定期备份**
   - 定期备份数据库
   - 备份上传的文件

5. **更新系统**
   - 定期更新 BookStack 镜像
   - 关注安全公告

## 参考资源

- 官方文档: https://www.bookstackapp.com/docs/
- 管理指南: https://www.bookstackapp.com/docs/admin/
- API 文档: https://demo.bookstackapp.com/api/docs

## 更新记录

- 2025-12-05: 初始版本，记录 BookStack 基础使用和配置
