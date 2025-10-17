# 使用官方 PHP 8.2 镜像
FROM php:8.2-cli

# 设置工作目录
WORKDIR /app

# 安装系统依赖和开发库
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libcurl4-openssl-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 PHP 扩展
# 注意：curl、dom、simplexml、xml 在 PHP 8.2 中已经内置，不需要单独安装
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 复制项目文件
COPY . .

# 安装依赖
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 创建必要的目录
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && mkdir -p storage/logs \
    && mkdir -p bootstrap/cache

# 设置权限
RUN chmod -R 775 storage bootstrap/cache \
    && chmod +x deploy.sh

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["bash", "deploy.sh"]
