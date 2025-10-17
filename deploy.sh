#!/bin/bash

echo "开始部署 CardSystem..."

# 设置环境变量
export APP_ENV=production
export APP_DEBUG=false

# 确保必要的目录存在
echo "创建必要的目录..."
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache

# 设置正确的权限
echo "设置文件权限..."
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# 生成应用密钥（如果不存在）
if [ -z "$APP_KEY" ]; then
    echo "生成应用密钥..."
    php artisan key:generate --force
fi

# 等待数据库就绪
echo "等待数据库连接..."
max_attempts=30
attempt=0
until php artisan migrate:status > /dev/null 2>&1 || [ $attempt -eq $max_attempts ]; do
    echo "等待数据库就绪... ($attempt/$max_attempts)"
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -eq $max_attempts ]; then
    echo "警告: 无法连接到数据库，将在没有数据库的情况下启动"
else
    echo "运行数据库迁移..."
    php artisan migrate --force
fi

# 清理并优化缓存
echo "优化应用..."
php artisan config:cache
php artisan route:cache

# 启动应用
echo "部署完成，启动应用..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
