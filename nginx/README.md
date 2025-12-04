# Nginx 配置说明

## 当前状态

Nginx 服务在 `docker-compose.yml` 中**默认禁用**（已注释）。

## 访问方式说明

BBS-GO 有两种访问方式：

### 方式 1: 直接访问（仅 API）
- **地址**: `http://localhost:8082`
- **说明**: 仅后端 API，无前端页面
- **用途**: 开发调试、API 测试

### 方式 2: 通过 Nginx 访问（推荐）
访问完整的前端+后端服务：

#### 内网访问
- **域名**: `bbs.local`
- **协议**: HTTP
- **端口**: 80
- **访问**: `http://bbs.local`

#### 公网访问
- **域名**: `bbs.slai-unofficial.online`
- **协议**: HTTP/HTTPS
- **端口**: 80 (HTTP), 443 (HTTPS)
- **访问**: `http://bbs.slai-unofficial.online`

**配置文件**: `nginx/conf.d/bbs-go.conf`

## 启用 Nginx

### 1. 取消注释 docker-compose.yml

编辑 `docker-compose.yml`，找到 nginx 服务并取消注释：

```yaml
services:
  nginx:
    container_name: community-nginx
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
      - ./nginx/logs:/var/log/nginx
    restart: always
    networks:
      - community-net
```

### 2. 启动 Nginx

```bash
docker-compose up -d nginx
```

### 3. 验证配置

```bash
# 检查配置文件语法
docker exec community-nginx nginx -t

# 重载配置
docker exec community-nginx nginx -s reload

# 查看日志
docker-compose logs -f nginx
```

## 域名解析配置

### 内网访问 (bbs.local)

修改客户端的 hosts 文件：

**Linux/Mac**: `/etc/hosts`
**Windows**: `C:\Windows\System32\drivers\etc\hosts`

添加：
```
192.168.x.x  bbs.local
```

或者使用 mDNS（需要启用 mdns 服务）：
```
community-hub.local
```

### 公网访问 (bbs.slai-unofficial.online)

在 DNS 服务商配置 A 记录：
```
bbs.slai-unofficial.online  →  你的公网IP
```

## SSL/HTTPS 配置

详见 [SSL-SETUP.md](./SSL-SETUP.md)

## 反向代理说明

Nginx 会将请求转发到：

- `/api/*` → `bbs-go:8082` (后端 API)
- `/*` → `bbs-go:3000` (前端页面)

## 日志位置

- 访问日志: `nginx/logs/*-access.log`
- 错误日志: `nginx/logs/*-error.log`

## 常见问题

### 1. 端口冲突

如果 80/443 端口已被占用，修改 `docker-compose.yml` 中的端口映射：

```yaml
ports:
  - "8080:80"    # 使用 8080 代替 80
  - "8443:443"   # 使用 8443 代替 443
```

### 2. 无法访问内网域名

确保：
1. DNS 解析正确（hosts 文件或 mDNS）
2. 防火墙允许访问
3. Nginx 容器正在运行：`docker-compose ps nginx`

### 3. 502 Bad Gateway

检查：
1. bbs-go 服务是否运行：`docker-compose ps bbsgo`
2. 网络是否正常：`docker exec community-nginx ping bbs-go`
3. 上游配置是否正确

## 自定义配置

在 `nginx/conf.d/` 目录下创建新的 `.conf` 文件，例如：

```nginx
# nginx/conf.d/custom.conf
server {
    listen 80;
    server_name example.com;
    # ... 你的配置
}
```

重启 Nginx：
```bash
docker-compose restart nginx
```
