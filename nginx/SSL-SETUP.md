# SSL 证书配置指南

## 方式 1：Let's Encrypt（推荐，免费自动续期）

### 使用 Certbot 获取证书

```bash
# 1. 安装 Certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx

# 2. 获取证书
sudo certbot certonly --standalone -d bbs.slai-unofficial.online

# 3. 证书位置（会自动生成在）
# /etc/letsencrypt/live/bbs.slai-unofficial.online/fullchain.pem
# /etc/letsencrypt/live/bbs.slai-unofficial.online/privkey.pem

# 4. 复制证书到项目目录
sudo cp /etc/letsencrypt/live/bbs.slai-unofficial.online/fullchain.pem ./nginx/ssl/bbs.slai-unofficial.online.crt
sudo cp /etc/letsencrypt/live/bbs.slai-unofficial.online/privkey.pem ./nginx/ssl/bbs.slai-unofficial.online.key
sudo chmod 644 ./nginx/ssl/bbs.slai-unofficial.online.crt
sudo chmod 600 ./nginx/ssl/bbs.slai-unofficial.online.key

# 5. 启用 Nginx HTTPS 配置
# 编辑 nginx/conf.d/bbs-go.conf，取消注释 HTTPS server 块

# 6. 启用 HTTP -> HTTPS 重定向
# 取消注释: return 301 https://$server_name$request_uri;

# 7. 重启 Nginx
docker-compose restart nginx

# 8. 设置自动续期（Let's Encrypt 证书 90 天过期）
sudo certbot renew --dry-run
```

## 方式 2：使用 Docker Certbot

```bash
# 1. 停止 Nginx（Let's Encrypt 需要 80 端口验证）
docker-compose stop nginx

# 2. 运行 Certbot 容器
docker run -it --rm \
  -v $(pwd)/nginx/ssl:/etc/letsencrypt \
  -p 80:80 \
  certbot/certbot certonly --standalone \
  -d bbs.slai-unofficial.online \
  --email your-email@example.com \
  --agree-tos

# 3. 重启 Nginx
docker-compose start nginx
```

## 方式 3：自签名证书（仅用于测试）

```bash
# 生成自签名证书（浏览器会警告不安全）
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/bbs.slai-unofficial.online.key \
  -out nginx/ssl/bbs.slai-unofficial.online.crt \
  -subj "/C=CN/ST=State/L=City/O=Organization/CN=bbs.slai-unofficial.online"
```

## 启用 HTTPS 后的配置

1. 编辑 `nginx/conf.d/bbs-go.conf`
2. 取消注释 HTTPS server 块
3. 启用 HTTP -> HTTPS 重定向
4. 重启 Nginx：`docker-compose restart nginx`

## 验证

```bash
# 检查证书
openssl x509 -in nginx/ssl/bbs.slai-unofficial.online.crt -text -noout

# 测试 HTTPS
curl -I https://bbs.slai-unofficial.online

# 检查 SSL 评级（外部工具）
# https://www.ssllabs.com/ssltest/
```

## 注意事项

1. **域名解析**：确保 `bbs.slai-unofficial.online` 已正确解析到服务器 IP
2. **防火墙**：确保开放 80（HTTP）和 443（HTTPS）端口
3. **证书续期**：Let's Encrypt 证书 90 天过期，需设置自动续期
4. **内网域名**：`bbs.local` 使用 HTTP，无需 SSL
