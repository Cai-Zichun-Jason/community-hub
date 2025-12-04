# HOST 配置指南

## 概述

BookStack 和 Homepage 服务需要正确配置 HOST 相关设置才能正常访问。本文档说明了如何配置和修改这些设置。

## 问题说明

### BookStack HOST 问题

**问题现象**：访问 BookStack 时会自动跳转到错误的域名导致无法访问

**原因**：BookStack 的 `APP_URL` 配置不正确，导致重定向到错误的地址

**解决方案**：需要设置正确的 `APP_URL` 环境变量

### Homepage HOST 问题

**问题现象**：访问 Homepage 时显示 "Host validation failed. See logs for more details."

**原因**：Homepage 默认启用了 Host 验证安全机制，拒绝来自未授权 HOST 的请求

**解决方案**：需要设置 `HOMEPAGE_ALLOWED_HOSTS` 环境变量允许特定的 HOST 访问

## 当前配置

### BookStack 配置位置

文件：`docker-compose.yml`

```yaml
bookstack:
  environment:
    - APP_URL=http://82.158.90.99:8083
```

### Homepage 配置位置

文件：`docker-compose.yml`

```yaml
homepage:
  environment:
    - HOMEPAGE_ALLOWED_HOSTS=localhost,82.158.90.99,82.158.90.99:8081
```

## 如何修改 IP 地址或域名

### 场景 1：更换服务器 IP 地址

假设新的 IP 地址是 `192.168.1.100`，端口保持不变：

1. **修改 BookStack 配置**

   编辑 `docker-compose.yml`，找到 BookStack 服务：

   ```yaml
   bookstack:
     environment:
       - APP_URL=http://192.168.1.100:8083  # 修改此行
   ```

2. **修改 Homepage 配置**

   编辑 `docker-compose.yml`，找到 Homepage 服务：

   ```yaml
   homepage:
     environment:
       - HOMEPAGE_ALLOWED_HOSTS=localhost,192.168.1.100,192.168.1.100:8081  # 修改此行
   ```

3. **重启服务**

   ```bash
   docker compose up -d bookstack homepage
   ```

### 场景 2：使用域名访问

假设使用域名 `community.example.com`，并通过反向代理访问：

1. **修改 BookStack 配置**

   ```yaml
   bookstack:
     environment:
       - APP_URL=https://community.example.com/bookstack  # 使用 HTTPS 和域名
   ```

2. **修改 Homepage 配置**

   ```yaml
   homepage:
     environment:
       - HOMEPAGE_ALLOWED_HOSTS=localhost,community.example.com  # 添加域名
   ```

   如果需要支持多个域名或 IP：

   ```yaml
   homepage:
     environment:
       - HOMEPAGE_ALLOWED_HOSTS=localhost,community.example.com,82.158.90.99,192.168.1.100
   ```

3. **配置反向代理**

   需要在 Nginx 配置中添加相应的反向代理规则（参考 `nginx/conf.d` 目录）

4. **重启服务**

   ```bash
   docker compose up -d bookstack homepage
   docker compose restart nginx
   ```

### 场景 3：本地开发环境（使用 localhost）

1. **修改 BookStack 配置**

   ```yaml
   bookstack:
     environment:
       - APP_URL=http://localhost:8083
   ```

2. **修改 Homepage 配置**

   ```yaml
   homepage:
     environment:
       - HOMEPAGE_ALLOWED_HOSTS=localhost,localhost:8081,127.0.0.1
   ```

3. **重启服务**

   ```bash
   docker compose up -d bookstack homepage
   ```

## 端口配置说明

当前端口配置在 `.env` 文件中：

```bash
HOMEPAGE_PORT=8081
BOOKSTACK_PORT=8083
```

### 修改端口的注意事项

如果需要修改端口，需要同步更新：

1. **修改 `.env` 文件**

   ```bash
   HOMEPAGE_PORT=8080  # 新端口
   BOOKSTACK_PORT=8084  # 新端口
   ```

2. **更新 HOST 配置**

   - BookStack: `APP_URL=http://your-ip:8084`
   - Homepage: `HOMEPAGE_ALLOWED_HOSTS=...,your-ip:8080`

3. **重启服务**

   ```bash
   docker compose up -d bookstack homepage
   ```

## 使用 Nginx 反向代理的配置

如果使用 Nginx 反向代理，建议配置如下：

### BookStack Nginx 配置示例

```nginx
server {
    listen 80;
    server_name bookstack.example.com;

    location / {
        proxy_pass http://bookstack:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

对应的 docker-compose.yml 配置：

```yaml
bookstack:
  environment:
    - APP_URL=http://bookstack.example.com  # 不需要端口号
```

### Homepage Nginx 配置示例

```nginx
server {
    listen 80;
    server_name homepage.example.com;

    location / {
        proxy_pass http://homepage:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

对应的 docker-compose.yml 配置：

```yaml
homepage:
  environment:
    - HOMEPAGE_ALLOWED_HOSTS=localhost,homepage.example.com
```

## 验证配置

### 验证 BookStack

```bash
# 应该看到 302 重定向到正确的登录页面
curl -I http://your-ip:8083

# 检查日志
docker compose logs bookstack --tail 20
```

### 验证 Homepage

```bash
# 应该看到 200 OK
curl -I http://your-ip:8081

# 检查日志，不应该有 "Host validation failed" 错误
docker compose logs homepage --tail 20
```

## 常见问题

### Q1: 修改配置后服务无法访问？

**解决方案**：
1. 检查配置文件语法是否正确
2. 确保重启了相关服务
3. 查看日志排查问题：`docker compose logs bookstack homepage`

### Q2: Homepage 仍然显示 "Host validation failed"？

**解决方案**：
1. 确认 `HOMEPAGE_ALLOWED_HOSTS` 包含了访问时使用的完整地址（包括端口）
2. 重启 Homepage 服务：`docker compose restart homepage`
3. 清除浏览器缓存后重试

### Q3: BookStack 重定向循环？

**解决方案**：
1. 确认 `APP_URL` 与实际访问地址完全一致
2. 如果使用反向代理，确保正确设置了 `X-Forwarded-*` 头
3. 重启 BookStack：`docker compose restart bookstack`

### Q4: 需要同时支持 IP 和域名访问？

**解决方案**：

Homepage 可以同时支持多个 HOST：

```yaml
homepage:
  environment:
    - HOMEPAGE_ALLOWED_HOSTS=localhost,192.168.1.100,192.168.1.100:8081,example.com
```

BookStack 只能配置一个主 URL，建议使用域名作为主 URL：

```yaml
bookstack:
  environment:
    - APP_URL=https://bookstack.example.com
```

如果需要通过 IP 访问，可以配置为 IP 地址，但可能影响某些功能（如邮件中的链接）。

## 更新记录

- 2025-12-05: 初始版本，记录当前 HOST 配置问题和解决方案
