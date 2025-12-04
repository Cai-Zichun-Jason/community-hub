#!/bin/bash
# =========================================
# Community Hub MySQL 初始化脚本
# 创建所有服务的数据库和用户
# =========================================

set -e

# 从环境变量读取密码（在 docker-compose 中传入）
GLOBAL_PASSWORD="${GLOBAL_PASSWORD:-SLAI#Community2025}"

echo "Initializing databases for Community Hub..."

# BookStack 数据库和用户
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS bookstack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS 'bookstack'@'%' IDENTIFIED BY '${GLOBAL_PASSWORD}';
    GRANT ALL PRIVILEGES ON bookstack.* TO 'bookstack'@'%';
EOSQL

# Homarr 数据库和用户
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS homarr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS 'homarr'@'%' IDENTIFIED BY '${GLOBAL_PASSWORD}';
    GRANT ALL PRIVILEGES ON homarr.* TO 'homarr'@'%';
    FLUSH PRIVILEGES;
EOSQL

echo "Databases initialized successfully!"
echo "Databases created: bookstack, homarr"
