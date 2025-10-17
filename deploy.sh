#!/bin/bash

echo "🚀 开始部署 CardSystem..."

# 设置环境变量
export APP_ENV=production
export APP_DEBUG=false

# 生成应用密钥（如果不存在）
if [ -z "$APP_KEY" ]; then
    echo "📝 生成应用密钥..."
    php artisan key:generate --force
fi

# 运行数据库迁移
echo "📦 运行数据库迁移..."
php artisan migrate --force

# 清理缓存
echo "🧹 清理缓存..."
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# 优化应用
echo "⚡ 优化应用..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 设置正确的权限
echo "🔐 设置文件权限..."
chmod -R 755 storage bootstrap/cache
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# 启动应用
echo "✅ 部署完成，启动应用..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
