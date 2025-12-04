# Homepage 配置指南

## 概述

Homepage 是一个高度可定制的主页/起始页/应用仪表板。所有配置文件位于 `./homepage/config/` 目录下。

## 配置文件结构

```
./homepage/config/
├── services.yaml      # 服务配置（显示的应用链接）
├── widgets.yaml       # 小部件配置（如日历、天气等）
├── bookmarks.yaml     # 书签配置
├── settings.yaml      # 全局设置
├── docker.yaml        # Docker 集成配置
├── custom.css         # 自定义样式
└── custom.js          # 自定义脚本
```

## 主要配置文件说明

### 1. services.yaml - 服务配置

这是最重要的配置文件，用于配置显示在主页上的服务卡片。

**当前配置示例**：

```yaml
---
# 第一组服务
- My First Group:
    - My First Service:
        href: http://localhost/
        description: Homepage is awesome

# 第二组服务
- My Second Group:
    - My Second Service:
        href: http://localhost/
        description: Homepage is the best
```

**修改为实际服务**：

```yaml
---
# Community Hub 服务
- 社区服务:
    - BBS 论坛:
        href: http://82.158.90.99:8082
        description: 社区论坛系统
        icon: mdi-forum

    - BookStack 文档:
        href: http://82.158.90.99:8083
        description: 知识库与文档管理
        icon: mdi-book-open-page-variant

# 管理工具
- 管理与监控:
    - MinIO 对象存储:
        href: http://82.158.90.99:8001
        description: 对象存储管理
        icon: mdi-database

    - Clash 面板:
        href: http://82.158.90.99:8002
        description: 网络代理管理
        icon: mdi-shield-check

# 外部链接
- 常用工具:
    - GitHub:
        href: https://github.com
        description: 代码托管平台
        icon: mdi-github
```

**服务配置选项**：

```yaml
- 组名:
    - 服务名:
        href: http://example.com         # 必填：服务链接
        description: 服务描述             # 可选：显示在服务名下方
        icon: mdi-icon-name              # 可选：图标（支持 mdi、si 等）
        target: _blank                   # 可选：打开方式（_blank 新窗口）
        ping: http://example.com         # 可选：启用 ping 监控
        widget:                          # 可选：集成服务 widget
          type: sonarr
          url: http://sonarr.host
          key: apikeyapikeyapikeyapikey
```

### 2. bookmarks.yaml - 书签配置

用于显示常用网站的快速链接。

**当前配置**：

```yaml
---
- Developer:
    - Github:
        - abbr: GH
          href: https://github.com/

- Social:
    - Reddit:
        - abbr: RE
          href: https://reddit.com/
```

**修改示例**：

```yaml
---
- 开发工具:
    - GitHub:
        - abbr: GH
          href: https://github.com/
    - GitLab:
        - abbr: GL
          href: https://gitlab.com/
    - Stack Overflow:
        - abbr: SO
          href: https://stackoverflow.com/

- 常用网站:
    - Google:
        - abbr: GG
          href: https://google.com/
    - Bilibili:
        - abbr: BL
          href: https://bilibili.com/

- 文档资源:
    - MDN:
        - abbr: MD
          href: https://developer.mozilla.org/
```

### 3. widgets.yaml - 小部件配置

配置显示在页面顶部的小部件。

**当前配置**：

```yaml
---
- widget:
    type: calendar
    firstDayInWeek: monday
    view: monthly
    maxEvents: 10
    showTime: true
    integrations:
      - type: ical
        url: https://...calendar.ics
        name: SLAI 活动日历
        color: blue
```

**常用小部件示例**：

```yaml
---
# 资源监控小部件
- resources:
    cpu: true
    memory: true
    disk: /
    uptime: true

# 搜索小部件
- search:
    provider: google
    target: _blank

# 天气小部件
- openmeteo:
    label: 上海
    latitude: 31.23
    longitude: 121.47
    units: metric
    cache: 5

# 日期时间小部件
- datetime:
    text_size: xl
    format:
      dateStyle: long
      timeStyle: short
      hour12: false
```

### 4. settings.yaml - 全局设置

配置 Homepage 的全局选项。

**基础配置示例**：

```yaml
---
# 页面标题
title: Community Hub

# 背景图片
background:
  image: /images/background.jpg
  blur: sm
  saturate: 50
  brightness: 50
  opacity: 50

# 图标风格
iconStyle: theme

# 语言设置
language: zh-CN

# 布局
layout:
  My First Group:
    style: row
    columns: 3

# 主题颜色
color: slate

# 外部提供商 API 密钥
providers:
  openweathermap: YOUR_API_KEY
  weatherapi: YOUR_API_KEY
```

### 5. docker.yaml - Docker 集成

显示 Docker 容器状态。

```yaml
---
# 使用本地 Docker socket
my-docker:
  socket: /var/run/docker.sock
```

**在 services.yaml 中使用 Docker widget**：

```yaml
- Docker 容器:
    - MySQL:
        href: http://localhost:8021
        description: 数据库服务
        widget:
          type: docker
          server: my-docker
          container: community-mysql
```

## 配置修改流程

### 方法 1：直接编辑配置文件

1. **编辑配置文件**

   ```bash
   # 编辑服务配置
   nano ./homepage/config/services.yaml

   # 编辑书签
   nano ./homepage/config/bookmarks.yaml

   # 编辑小部件
   nano ./homepage/config/widgets.yaml

   # 编辑全局设置
   nano ./homepage/config/settings.yaml
   ```

2. **刷新页面查看效果**

   大多数配置修改后，只需刷新浏览器即可看到效果（无需重启容器）。

3. **如果修改未生效，重启容器**

   ```bash
   docker compose restart homepage
   ```

### 方法 2：使用 VS Code 编辑

推荐使用支持 YAML 语法高亮的编辑器：

```bash
code ./homepage/config/
```

### 注意事项

1. **YAML 语法严格**
   - 使用空格缩进，不能使用 Tab
   - 注意冒号后需要空格
   - 列表项使用 `-` 开头

2. **配置验证**
   - 修改后检查 Docker 日志：`docker compose logs homepage`
   - 如果有语法错误，日志会显示错误信息

3. **备份配置**
   - 修改前建议备份：`cp -r ./homepage/config ./homepage/config.backup`

## 实用配置示例

### 完整的社区服务配置

**services.yaml**:

```yaml
---
# Community Hub 核心服务
- 核心服务:
    - BBS 论坛:
        href: http://82.158.90.99:8082
        description: 社区论坛讨论
        icon: mdi-forum-outline
        ping: http://82.158.90.99:8082
        widget:
          type: docker
          server: my-docker
          container: bbs-go

    - BookStack:
        href: http://82.158.90.99:8083
        description: 知识库文档
        icon: mdi-book-open-variant
        ping: http://82.158.90.99:8083
        widget:
          type: docker
          server: my-docker
          container: bookstack

# 存储与数据
- 存储服务:
    - MinIO 控制台:
        href: http://82.158.90.99:8001
        description: 对象存储管理
        icon: mdi-database-outline
        widget:
          type: docker
          server: my-docker
          container: community-minio

    - MySQL:
        href: http://82.158.90.99:8021
        description: 数据库服务
        icon: mdi-database
        widget:
          type: docker
          server: my-docker
          container: community-mysql

# 网络工具
- 网络代理:
    - Clash 面板:
        href: http://82.158.90.99:8002
        description: 代理管理
        icon: mdi-shield-network
```

**widgets.yaml**:

```yaml
---
# 系统资源监控
- resources:
    cpu: true
    memory: true
    disk: /
    uptime: true
    label: 服务器状态

# 搜索框
- search:
    provider: google
    target: _blank

# 当前时间
- datetime:
    text_size: xl
    format:
      dateStyle: long
      timeStyle: short
      hour12: false
```

## 高级功能

### 1. 服务健康检查

```yaml
- My Service:
    href: http://example.com
    ping: http://example.com/health
```

### 2. 自定义样式

编辑 `custom.css`：

```css
/* 自定义主题颜色 */
:root {
    --primary-color: #3b82f6;
}

/* 自定义服务卡片样式 */
.service-card {
    border-radius: 12px;
}
```

### 3. Docker 容器监控

显示容器 CPU、内存使用情况：

```yaml
- MySQL:
    widget:
      type: docker
      server: my-docker
      container: community-mysql
      showStats: true
```

## 常见问题

### Q1: 修改配置后页面没有变化？

**解决方案**：
1. 清除浏览器缓存（Ctrl+F5）
2. 检查 YAML 语法是否正确
3. 重启 Homepage：`docker compose restart homepage`
4. 查看日志：`docker compose logs homepage`

### Q2: 如何添加图标？

**解决方案**：

支持多种图标库：

```yaml
# Material Design Icons (mdi-)
icon: mdi-home

# Simple Icons (si-)
icon: si-github

# 自定义图片
icon: /icons/custom.png
```

查找图标：
- MDI: https://pictogrammers.com/library/mdi/
- Simple Icons: https://simpleicons.org/

### Q3: Widget 不显示？

**解决方案**：
1. 确认相关服务已启动
2. 检查 API 密钥是否正确
3. 查看浏览器控制台错误信息
4. 检查 docker.yaml 配置是否正确

### Q4: 如何更改语言？

在 `settings.yaml` 中添加：

```yaml
language: zh-CN  # 中文
# language: en    # 英文
```

## 参考资源

- 官方文档: https://gethomepage.dev/
- 服务配置: https://gethomepage.dev/configs/services/
- Widget 配置: https://gethomepage.dev/widgets/
- 图标库: https://pictogrammers.com/library/mdi/

## 更新记录

- 2025-12-05: 初始版本，记录 Homepage 配置方法
