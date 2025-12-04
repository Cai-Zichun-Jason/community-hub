<div align="center">

# Community Hub

**一键部署的全栈社区服务平台**
**All-in-One Community Services Platform**

集成论坛、导航门户、知识库、对象存储、代理管理等多种服务
Integrated forum, portal, wiki, object storage, proxy management, and more

[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue.svg)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2.0%2B-blue.svg)](https://docs.docker.com/compose/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[GitHub](https://github.com/Cai-Zichun-Jason/Easy-Setup/) · [Gitee](https://gitee.com/Cai-Zichun-Jason/community-hub) · [文档 Docs](SERVICES.md)

[中文](#-项目简介-project-overview) · [English](#-quick-start)

</div>

---

## 📖 项目简介 | Project Overview

**Community Hub** 是一个基于 Docker Compose 编排的开源社区服务平台，旨在通过简单的配置实现多服务的快速部署和统一管理。适合个人开发者、小团队或社区组织搭建私有化的全栈服务环境。

**Community Hub** is an open-source community services platform orchestrated with Docker Compose, designed for quick deployment and unified management of multiple services. Perfect for individual developers, small teams, or community organizations to build a self-hosted full-stack environment.

### ✨ 核心特性 | Key Features

- 🚀 **一键部署** - 基于 Docker Compose，5 分钟内启动所有服务
- 🔒 **数据持久化** - 所有数据本地存储，支持备份和迁移
- 🌐 **域名支持** - 通过 Nginx 反向代理实现统一域名访问
- 🛡️ **安全可靠** - 环境变量统一管理，密码加密存储
- 📦 **模块化设计** - 各服务独立运行，按需启用或禁用
- 🔧 **易于维护** - 清晰的目录结构，详细的配置文档

### 🎯 服务清单 | Service List

| 服务 Service | 描述 Description | 访问端口 Port | 内网域名 Domain |
|-------------|------------------|--------------|----------------|
| **Nginx** | 反向代理和负载均衡<br/>Reverse proxy & load balancer | 80/443 | - |
| **Homarr** | 导航门户和服务仪表板<br/>Portal & dashboard | 8081 | portal.local |
| **BBS-GO** | 功能完整的社区论坛<br/>Full-featured forum | 8082 | bbs.local |
| **BookStack** | 知识库和文档系统<br/>Wiki & documentation | 8083 | blog.local |
| **MinIO** | S3 兼容对象存储<br/>S3-compatible object storage | 9001/9022 | minio.local |
| **MetaCubeX** | 代理管理界面<br/>Proxy management UI | 9002 | clash.local |
| **Mihomo** | 代理核心服务<br/>Proxy core service | 9023 | vpn.local |
| **MySQL** | 关系型数据库<br/>Relational database | 9021 | - |
| **mDNS** | 局域网服务发现<br/>LAN service discovery | - | - |

详细服务说明请查看 [SERVICES.md](SERVICES.md)
See [SERVICES.md](SERVICES.md) for detailed service documentation

---

## 📋 系统要求 | System Requirements

| 项目 Item | 最低要求 Minimum | 推荐配置 Recommended |
|-----------|-----------------|---------------------|
| **操作系统 OS** | Linux / macOS / Windows (WSL2) | Ubuntu 20.04+ / macOS 12+ |
| **Docker** | 20.10+ | Latest stable |
| **Docker Compose** | 2.0+ | Latest stable |
| **CPU** | 2 cores | 4+ cores |
| **内存 RAM** | 4 GB | 8+ GB |
| **硬盘空间 Storage** | 20 GB | 50+ GB (SSD) |

---

## 🚀 快速开始 | Quick Start

### 1️⃣ 克隆项目 | Clone Repository

```bash
# 从 GitHub 克隆 | Clone from GitHub
git clone https://github.com/Cai-Zichun-Jason/Easy-Setup.git community-hub

# 或从 Gitee 克隆（国内推荐）| Or clone from Gitee (recommended for China)
git clone https://gitee.com/Cai-Zichun-Jason/community-hub.git

cd community-hub
```

### 2️⃣ 配置环境变量 | Configure Environment

```bash
# 复制环境变量示例文件 | Copy example environment file
cp .env.example .env

# 编辑 .env 文件 | Edit .env file
nano .env  # or vim, code, etc.
```

**⚠️ 重要 Important**: 请务必修改 `.env` 文件中的 `GLOBAL_PASSWORD`，设置一个强密码！
**Please change `GLOBAL_PASSWORD` in `.env` to a strong password!**

推荐密码格式 | Recommended password format:
- 长度 ≥ 16 位 | Length ≥ 16 characters
- 包含大小写字母、数字、特殊字符 | Include uppercase, lowercase, numbers, special chars
- 示例 | Example: `MyS3cur3P@ssw0rd!2025`

### 3️⃣ 启动服务 | Start Services

```bash
# 启动所有服务 | Start all services
docker compose up -d

# 查看服务状态 | Check service status
docker compose ps

# 查看日志 | View logs
docker compose logs -f
```

### 4️⃣ 访问服务 | Access Services

启动成功后，可通过以下方式访问 | After successful startup, access via:

#### 方式一：直接端口访问 | Method 1: Direct Port Access

- 导航门户 Portal: http://localhost:8081
- 论坛系统 Forum: http://localhost:8082
- 知识库 Wiki: http://localhost:8083
- MinIO 控制台 Console: http://localhost:9001
- 代理管理 Proxy UI: http://localhost:9002
- 代理 API VPN API: http://localhost:9090

#### 方式二：域名访问（需配置 hosts）| Method 2: Domain Access (requires hosts config)

- 导航门户 Portal: http://portal.local
- 论坛系统 Forum: http://bbs.local
- 知识库 Wiki: http://blog.local
- MinIO 控制台 Console: http://minio.local
- 代理管理 Proxy UI: http://vpn.local

**配置 hosts 文件 | Configure hosts file:**

编辑 | Edit:
- Linux/Mac: `/etc/hosts`
- Windows: `C:\Windows\System32\drivers\etc\hosts`

添加以下内容（替换为你的��务器 IP）| Add the following (replace with your server IP):

```
192.168.1.100  portal.local
192.168.1.100  bbs.local
192.168.1.100  blog.local
192.168.1.100  minio.local
192.168.1.100  vpn.local
192.168.1.100  proxy.local
```

---

## 📁 项目结构 | Project Structure

```
community-hub/
├── docker compose.yml          # Docker 编排配置 | Docker orchestration
├── .env                        # 环境变量（需从 .env.example 复制）| Environment variables
├── .env.example                # 环境变量示例 | Example env file
├── .gitignore                  # Git 忽略配置 | Git ignore rules
├── README.md                   # 项目文档 | Project documentation
├── SERVICES.md                 # 服务详细说明 | Service details
├── LICENSE                     # MIT 许可证 | MIT License
│
├── mysql/                      # MySQL 数据库 | MySQL database
│   ├── data/                   # 数据文件（自动生成）| Data files (auto-generated)
│   └── init/                   # 初始化脚本 | Init scripts
│
├── minio/                      # MinIO 对象存储 | MinIO object storage
│   └── data/                   # 存储数据（自动生成）| Storage data (auto-generated)
│
├── nginx/                      # Nginx 反向代理 | Nginx reverse proxy
│   ├── conf.d/                 # 配置文件 | Configuration files
│   ├── ssl/                    # SSL 证书 | SSL certificates
│   └── logs/                   # 访问日志 | Access logs
│
├── bbs/                        # BBS-GO 论坛 | BBS-GO forum
│   ├── bbs-go.yaml             # 配置文件（自动生成）| Config (auto-generated)
│   └── uploads/                # 上传文件（自动生成）| Uploads (auto-generated)
│
├── homarr/                     # Homarr 导航门户 | Homarr portal
│   ├── configs/                # 配置文件（自动生成）| Configs (auto-generated)
│   ├── icons/                  # 图标文件（自动生成）| Icons (auto-generated)
│   └── data/                   # 数据文件（自动生成）| Data (auto-generated)
│
├── bookstack/                  # BookStack 知识库 | BookStack wiki
│   └── config/                 # 配置文件（自动生成）| Config (auto-generated)
│
├── clash/                      # MetaCubeX 界面 | MetaCubeX UI
│   └── data/                   # 数据文件（自动生成）| Data (auto-generated)
│
└── mihomo/                     # Mihomo 代理核心 | Mihomo proxy core
    └── config/                 # 配置文件 | Configuration files
```

---

## 🔧 常用命令 | Common Commands

### 服务管理 | Service Management

```bash
# 启动所有服务 | Start all services
docker compose up -d

# 停止所有服务 | Stop all services
docker compose down

# 重启所有服务 | Restart all services
docker compose restart

# 重启单个服务 | Restart a specific service
docker compose restart nginx

# 查看服务状态 | Check service status
docker compose ps

# 查看服务日志 | View service logs
docker compose logs -f [service_name]

# 查看特定服务日志 | View specific service logs
docker compose logs -f homarr
docker compose logs -f bbsgo
```

### 数据管理 | Data Management

```bash
# 备份数据 | Backup data
tar -czf backup-$(date +%Y%m%d).tar.gz \
  mysql/data minio/data bbs/uploads homarr bookstack

# 恢复数据 | Restore data
docker compose down
tar -xzf backup-20251204.tar.gz
docker compose up -d

# 清理所有数据（危险操作！）| Clean all data (DANGEROUS!)
docker compose down -v
sudo rm -rf mysql/data/* minio/data/* bbs/uploads/*
docker compose up -d
```

### 镜像管理 | Image Management

```bash
# 拉取最新镜像 | Pull latest images
docker compose pull

# 重新构建并启动 | Rebuild and restart
docker compose up -d --build

# 清理未使用的镜像 | Clean unused images
docker image prune -a
```

---

## 🔒 安全建议 | Security Recommendations

### 1. 修改默认密码 | Change Default Passwords

```bash
# 编辑 .env 文件 | Edit .env file
nano .env

# 修改 GLOBAL_PASSWORD | Change GLOBAL_PASSWORD
GLOBAL_PASSWORD=YourStrongPasswordHere
```

**强密码建议 | Strong password guidelines:**
- 至少 16 位字符 | At least 16 characters
- 包含大小写字母 | Include uppercase and lowercase
- 包含数字和特殊字符 | Include numbers and special characters
- 不使用常见单词 | Avoid common words
- 定期更换（建议 90 天）| Change regularly (recommended every 90 days)

### 2. 配置防火墙 | Configure Firewall

```bash
# Ubuntu/Debian
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 3. 启用 HTTPS | Enable HTTPS

使用 Let's Encrypt 获取免费 SSL 证书 | Use Let's Encrypt for free SSL certificates:

```bash
# 安装 Certbot | Install Certbot
sudo apt install certbot

# 获取证书 | Obtain certificate
sudo certbot certonly --standalone -d yourdomain.com

# 更新 Nginx 配置 | Update Nginx configuration
# 编辑 nginx/conf.d/default.conf
```

### 4. 定期备份 | Regular Backups

建议设置自动备份 cron 任务 | Recommended to set up automated backup cron job:

```bash
# 编辑 crontab | Edit crontab
crontab -e

# 添加每周日凌晨 2 点备份 | Add weekly backup at 2 AM on Sundays
0 2 * * 0 cd /path/to/community-hub && tar -czf backup-$(date +\%Y\%m\%d).tar.gz mysql/data minio/data bbs/uploads
```

### 5. 更新服务 | Update Services

```bash
# 拉取最新镜像 | Pull latest images
docker compose pull

# 重启服务应用更新 | Restart to apply updates
docker compose up -d

# 检查更新后的状态 | Check status after update
docker compose ps
```

---

## 🐛 故障排查 | Troubleshooting

### 服务启动失败 | Service Start Failure

```bash
# 查看详细日志 | View detailed logs
docker compose logs [service_name]

# 检查端口占用 | Check port usage
sudo netstat -tunlp | grep -E "80|443|8081|8082|8083|9001"

# 重新创建容器 | Recreate containers
docker compose down
docker compose up -d --force-recreate
```

### 无法访问服务 | Cannot Access Services

**检查清单 | Checklist:**

1. 服务是否正常运行 | Check if services are running:
   ```bash
   docker compose ps
   ```

2. 防火墙是否开放端口 | Check if firewall allows ports:
   ```bash
   sudo ufw status
   ```

3. 端口映射是否正确 | Check port mappings:
   ```bash
   docker compose port homarr 7575
   ```

4. 查看 Nginx 日志 | Check Nginx logs:
   ```bash
   docker compose logs nginx
   ```

### 数据库连接失败 | Database Connection Failure

```bash
# 检查 MySQL 容器状态 | Check MySQL container status
docker compose ps mysql

# 查看 MySQL 日志 | View MySQL logs
docker compose logs mysql

# 测试数据库连接 | Test database connection
docker exec -it community-mysql mysql -uroot -p

# 检查数据库是否初始化 | Check if database is initialized
docker exec -it community-mysql mysql -uroot -p -e "SHOW DATABASES;"
```

### 权限问题 | Permission Issues

```bash
# 修复数据目录权限 | Fix data directory permissions
sudo chown -R $USER:$USER mysql/ minio/ bbs/ homarr/ bookstack/
sudo chmod -R 755 mysql/ minio/ bbs/ homarr/ bookstack/

# 如果使用 Docker rootless 模式 | If using Docker rootless mode
docker compose down
sudo chown -R $(id -u):$(id -g) mysql/ minio/ bbs/ homarr/ bookstack/
docker compose up -d
```

### 磁盘空间不足 | Disk Space Issues

```bash
# 查看磁盘使用情况 | Check disk usage
df -h

# 清理 Docker 资源 | Clean Docker resources
docker system prune -a --volumes

# 查看 Docker 占用空间 | Check Docker disk usage
docker system df
```

---

## 🤝 贡献指南 | Contributing

欢迎各种形式的贡献！| Contributions are welcome!

### 贡献方式 | How to Contribute

1. **报告问题 | Report Issues**
   - 在 [GitHub Issues](https://github.com/Cai-Zichun-Jason/Easy-Setup/issues) 提交 bug 报告或功能建议

2. **提交代码 | Submit Code**
   ```bash
   # Fork 本项目 | Fork this repository
   # 创建特性分支 | Create feature branch
   git checkout -b feature/AmazingFeature

   # 提交更改 | Commit changes
   git commit -m 'Add some AmazingFeature'

   # 推送到分支 | Push to branch
   git push origin feature/AmazingFeature

   # 创建 Pull Request | Create Pull Request
   ```

3. **改进文档 | Improve Documentation**
   - 修正错误、补充说明、翻译文档

### 开发规范 | Development Guidelines

- 遵循现有代码风格 | Follow existing code style
- 编写清晰的提交信息 | Write clear commit messages
- 添加必要的注释和文档 | Add necessary comments and documentation
- 测试你的更改 | Test your changes

---

## 📝 更新日志 | Changelog

### v1.0.0 (2024-12-04)

**新增 | Added:**
- 集成 BBS-GO 论坛系统 | Integrated BBS-GO forum
- 集成 Homarr 导航门户 | Integrated Homarr portal
- 集成 BookStack 知识库 | Integrated BookStack wiki
- 集成 MinIO 对象存储 | Integrated MinIO object storage
- 集成 Mihomo 代理服务 | Integrated Mihomo proxy
- 添加 Nginx 反向代理支持 | Added Nginx reverse proxy
- 统一环境变量管理 | Unified environment variable management
- 完整的中英文文档 | Complete bilingual documentation

---

## 📄 许可证 | License

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件
This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details

---

## 🔗 相关链接 | Links

### 官方文档 | Official Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [BBS-GO](https://github.com/mlogclub/bbs-go)
- [Homarr](https://homarr.dev/)
- [BookStack](https://www.bookstackapp.com/)
- [MinIO](https://min.io/docs/minio/linux/index.html)
- [Mihomo](https://github.com/MetaCubeX/mihomo)

### 项目仓库 | Repository

- GitHub: https://github.com/Cai-Zichun-Jason/Easy-Setup/
- Gitee: https://gitee.com/Cai-Zichun-Jason/community-hub

---

## ⭐ Star History

如果这个项目对你有帮助，欢迎给个 Star！
If this project helps you, please give it a Star!

[![Star History Chart](https://api.star-history.com/svg?repos=Cai-Zichun-Jason/Easy-Setup&type=Date)](https://star-history.com/#Cai-Zichun-Jason/Easy-Setup&Date)

---

## 💬 联系方式 | Contact

- 提交 Issue | Submit Issue: [GitHub Issues](https://github.com/Cai-Zichun-Jason/Easy-Setup/issues)
- 讨论交流 | Discussion: [GitHub Discussions](https://github.com/Cai-Zichun-Jason/Easy-Setup/discussions)

---

<div align="center">

**Made with ❤️ by Community**

[⬆ 回到顶部 | Back to Top](#community-hub)

</div>
