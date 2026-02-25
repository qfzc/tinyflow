#!/bin/bash
# 自动构建和发布脚本

set -e

echo "🚀 tinyflow 自动化脚本"
echo "================================"

# 检查是否在 git 仓库中
if [ ! -d ".git" ]; then
    echo "❌ 错误：当前目录不是 git 仓库"
    exit 1
fi

# 获取当前分支
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📍 当前分支: $CURRENT_BRANCH"

# 1. 安装依赖
echo ""
echo "📦 安装依赖..."
pnpm install

# 2. 运行构建
echo ""
echo "🔨 构建所有包..."
pnpm build

# 3. 运行测试（如果有）
echo ""
echo "🧪 运行测试..."
if [ -f "package.json" ]; then
    if grep -q '"test"' package.json; then
        pnpm test
    else
        echo "⏭️  未找到测试脚本，跳过"
    fi
fi

# 4. Git 操作
echo ""
echo "📝 Git 操作..."

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有需要提交的更改"
else
    echo "📄 发现更改，自动提交..."
    git add .
    git commit -m "chore: 自动提交构建产物 $(date +'%Y-%m-%d %H:%M:%S')" || echo "⚠️  没有新的更改需要提交"
fi

# 5. 推送到 GitHub
echo ""
echo "⬆️  推送到 GitHub..."
git push origin $CURRENT_BRANCH

# 6. 询问是否发布到 npm（仅在 main 分支）
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo ""
    read -p "📦 是否发布到 npm? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 发布到 npm..."
        pnpm release
    fi
else
    echo "ℹ️  非 main 分支，跳过发布"
fi

echo ""
echo "✅ 自动化流程完成！"
