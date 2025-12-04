# Community Hub 服务列表

## 📋 服务域名映射

| 服务 | 内网域名 | 公网域名（示例） | 直接访问端口 | 说明 |
|------|----------|-----------------|-------------|------|
| **Homarr** | portal.local | portal.example.com | 8081 | 导航门户 |
| **BBS-GO** | bbs.local | bbs.example.com | 8082 | 论坛系统 |
| **BookStack** | blog.local | blog.example.com | 8083 | 知识库/博客 |
| **MinIO Console** | minio.local | minio.example.com | 9001 | 对象存储控制台 |
| **MetaCubeX** | clash.local | clash.example.com | 9002 | 代理管理界面 |
| **Mihomo** | vpn.local | vpn.example.com | 9023 | 代理核心服务 |
| **MySQL** | - | - | 9021 | 数据库 |
| **MinIO API** | - | - | 9022 | S3 API |

## 🌐 访问方式

### 方式 1: 通过域名访问（需要启用 Nginx）

**内网访问示例：**
- 导航门户: `http://portal.local`
- 论坛: `http://bbs.local`
- 博客: `http://blog.local`
- VPN 管理: `http://vpn.local`

**公网访问示例：**
- 导航门户: `http://portal.example.com`
- 论坛: `http://bbs.example.com`
- 博客: `http://blog.example.com`
- VPN 管理: `http://vpn.example.com`

### 方式 2: 直接访问端口（开发调试）

- Homarr: `http://localhost:8081`
- BBS-GO API: `http://localhost:8082`
- BookStack: `http://localhost:8083`
- MinIO Console: `http://localhost:9001`
- MetaCubeX: `http://localhost:9002`
- Mihomo API: `http://localhost:9023`

## 🔧 代理端口

Mihomo 提供的代理服务端口：

| 协议 | 端口 | 说明 |
|------|------|------|
| HTTP | 7890 | HTTP 代理 |
| SOCKS5 | 7891 | SOCKS5 代理 |
| API | 9023 | 管理 API（通过 Nginx 为 proxy.local） |

## 📝 域名配置

### 内网访问配置

编辑 `/etc/hosts`（Linux/Mac）或 `C:\Windows\System32\drivers\etc\hosts`（Windows）：

```
192.168.x.x  portal.local
192.168.x.x  bbs.local
192.168.x.x  blog.local
192.168.x.x  minio.local
192.168.x.x  vpn.local
192.168.x.x  proxy.local
```

### 公网访问配置

在 DNS 服务商配置以下 A 记录（全部指向你的公网 IP）：

```
portal.example.com
bbs.example.com
blog.example.com
minio.example.com
vpn.example.com
proxy.example.com
```

## 🚀 服务说明

### Homarr (Portal)
- **用途**: 统一导航门户，聚合所有服务入口
- **数据库**: MySQL (`homarr` 数据库)
- **配置目录**: `./homarr/`

### BBS-GO (BBS)
- **用途**: 社区论坛系统
- **数据库**: MySQL (`bbsgo_db` 数据库)
- **存储**: MinIO + 本地 uploads
- **配置目录**: `./bbs/`

### BookStack (Blog)
- **用途**: 知识库/博客/文档系统
- **数据库**: MySQL (`bookstack` 数据库)
- **配置目录**: `./bookstack/`

### MinIO
- **用途**: S3 兼容对象存储
- **访问方式**:
  - 控制台: `http://minio.local` 或 `http://localhost:9001`
  - API: `http://localhost:9022`
- **数据目录**: `./minio/data/`

### MetaCubeX (VPN)
- **用途**: Mihomo 代理的 Web 管理界面
- **配置目录**: `./metacubex/`

### Mihomo (Proxy)
- **用途**: 代理核心（Clash Meta 核心）
- **配置目录**: `./mihomo/config/`
- **代理端口**: 7890 (HTTP), 7891 (SOCKS5)

## 🔐 默认凭据

### MySQL
- 用户名: `root`
- 密码: `123456` (旧数据兼容)
- 新服务密码: `SLAI#Community2025`

### MinIO
- 用户名: `root`
- 密码: `SLAI#Community2025`

### 各服务数据库
| 服务 | 数据库名 | 用户名 | 密码 |
|------|---------|--------|------|
| BBS-GO | bbsgo_db | bbsgo | 123456 |
| Homarr | homarr | homarr | SLAI#Community2025 |
| BookStack | bookstack | bookstack | SLAI#Community2025 |

## 📦 快速启动

### 启动所有服务

```bash
docker compose up -d
```

### 启动特定服务

```bash
# 仅启动 Homarr
docker compose up -d homarr

# 仅启动论坛
docker compose up -d bbsgo

# 仅启动博客
docker compose up -d bookstack
```

### 查看服务状态

```bash
docker compose ps
```

### 查看服务日志

```bash
# 查看所有日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f homarr
docker compose logs -f bookstack
```

## 🛡️ 安全建议

1. **修改默认密码**: 生产环境请修改 `.env` 中的 `GLOBAL_PASSWORD`
2. **启用 HTTPS**: 为公网域名配置 SSL 证书（详见 `nginx/SSL-SETUP.md`）
3. **限制访问**: 考虑为敏感服务（如 VPN 管理）添加认证
4. **防火墙**: 限制不必要的端口对外开放
