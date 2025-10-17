# Railway 部署指南

本指南将帮助你在 Railway 上部署 CardSystem 项目。

## 前提条件

1. 拥有一个 [Railway](https://railway.app) 账号
2. 将此项目推送到 GitHub 仓库

## 部署步骤

### 1. 创建新项目

1. 登录 [Railway](https://railway.app)
2. 点击 "New Project"
3. 选择 "Deploy from GitHub repo"
4. 选择你的 CardSystem 仓库

### 2. 添加 MySQL 数据库

1. 在项目中点击 "+ New"
2. 选择 "Database" → "Add MySQL"
3. 等待数据库创建完成
4. 数据库会自动生成连接信息

### 3. 配置环境变量

在你的服务设置中，进入 "Variables" 标签页，添加以下环境变量：

#### 必需的环境变量

```bash
# 应用配置
APP_NAME=CardSystem
APP_ENV=production
APP_DEBUG=false
APP_LOG_LEVEL=error
APP_LOG=daily

# 应用密钥（Railway 会自动生成，或者你可以在本地运行 php artisan key:generate 获取）
APP_KEY=base64:your_generated_key_here

# 数据库配置（使用 Railway MySQL 的连接信息）
DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQL_HOST}}
DB_PORT=${{MySQL.MYSQL_PORT}}
DB_DATABASE=${{MySQL.MYSQL_DATABASE}}
DB_USERNAME=${{MySQL.MYSQL_USER}}
DB_PASSWORD=${{MySQL.MYSQL_PASSWORD}}

# 会话和缓存配置
BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
SESSION_LIFETIME=120
QUEUE_DRIVER=sync
```

#### 可选的环境变量

如果你需要 Redis：

```bash
REDIS_HOST=${{Redis.REDIS_HOST}}
REDIS_PASSWORD=${{Redis.REDIS_PASSWORD}}
REDIS_PORT=${{Redis.REDIS_PORT}}
```

### 4. 数据库引用配置

Railway 会自动为数据库服务生成环境变量。你需要确保在应用服务的环境变量中引用这些变量：

1. 点击你的应用服务
2. 进入 "Settings" → "Service Variables"
3. 点击 "Reference" 按钮
4. 选择 MySQL 服务
5. 添加数据库连接变量的引用

### 5. 生成应用密钥

如果你没有 `APP_KEY`，有两种方式生成：

**方式 1：本地生成**
```bash
php artisan key:generate --show
```
然后将生成的密钥复制到 Railway 环境变量中。

**方式 2：Railway 自动生成**
部署脚本会自动检测并生成密钥（如果不存在）。

### 6. 部署配置说明

本项目已经配置了以下文件来支持 Railway 部署：

- **nixpacks.toml**: 定义 PHP 环境和构建步骤
- **Procfile**: 定义启动命令
- **deploy.sh**: 部署脚本，包含数据库迁移和缓存优化
- **railway.json**: Railway 特定配置

### 7. 触发部署

1. 确保所有环境变量都已正确配置
2. Railway 会自动开始构建和部署
3. 查看 "Deployments" 标签页监控部署进度
4. 部署成功后，点击生成的 URL 访问你的应用

## 常见问题

### 数据库连接失败

确保：
- MySQL 服务已启动
- 数据库环境变量正确引用了 MySQL 服务的变量
- 检查 Railway 日志中的错误信息

### APP_KEY 错误

如果看到 "No application encryption key has been specified" 错误：
1. 确保 `APP_KEY` 环境变量已设置
2. 密钥格式应为: `base64:...`
3. 重新部署应用

### 文件权限错误

部署脚本会自动设置 `storage` 和 `bootstrap/cache` 目录的权限。如果仍有问题，检查 Railway 日志。

### 迁移失败

如果数据库迁移失败：
1. 检查数据库连接配置
2. 查看 Railway 部署日志中的详细错误信息
3. 确保数据库服务正在运行

## 环境变量模板

创建一个 `.env.railway` 文件（不要提交到 Git）作为参考：

```bash
APP_NAME=CardSystem
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:your_key_here
APP_LOG_LEVEL=error
APP_LOG=daily

DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQL_HOST}}
DB_PORT=${{MySQL.MYSQL_PORT}}
DB_DATABASE=${{MySQL.MYSQL_DATABASE}}
DB_USERNAME=${{MySQL.MYSQL_USER}}
DB_PASSWORD=${{MySQL.MYSQL_PASSWORD}}

BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
SESSION_LIFETIME=120
QUEUE_DRIVER=sync
```

## 更新应用

当你推送新代码到 GitHub 时，Railway 会自动检测更改并重新部署。

## 监控和日志

- 在 Railway 控制台的 "Logs" 标签页查看实时日志
- 使用 "Metrics" 标签页监控资源使用情况
- 设置 "Webhooks" 接收部署通知

## 成本优化

- Railway 提供免费额度（$5/月）
- 使用 "Sleep on idle" 功能降低成本（在项目设置中）
- 监控资源使用情况避免超额

## 技术支持

如果遇到问题：
1. 查看 [Railway 文档](https://docs.railway.app)
2. 查看项目的 [GitHub Issues](https://github.com/Tai7sy/card-system/issues)
3. 检查 Railway 社区论坛

## 下一步

部署成功后：
1. 访问你的应用 URL
2. 完成应用的初始化设置
3. 配置支付网关和其他功能
4. 设置域名（在 Railway 项目设置中）

---

祝部署顺利！ 🚀
