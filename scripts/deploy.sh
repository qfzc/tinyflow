#!/bin/bash
# 一键自动化脚本：构建、提交、推送

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}🚀 tinyflow 一键自动化脚本${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# 检查目录
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}❌ 请在项目根目录运行此脚本${NC}"
    exit 1
fi

# 1. 拉取最新代码
echo -e "${BLUE}[1/6] 📥 拉取最新代码...${NC}"
git pull origin main || echo -e "${YELLOW}⚠️  Pull 失败或已是最新${NC}"

# 2. 安装依赖
echo ""
echo -e "${BLUE}[2/6] 📦 安装依赖...${NC}"
pnpm install

# 3. 代码检查（可选）
echo ""
echo -e "${BLUE}[3/6] 🔍 代码检查...${NC}"
if grep -q '"lint"' package.json; then
    pnpm lint || echo -e "${YELLOW}⚠️  Lint 检查失败，继续构建${NC}"
else
    echo -e "${YELLOW}⏭️  未配置 lint，跳过${NC}"
fi

# 4. 构建所有包
echo ""
echo -e "${BLUE}[4/6] 🔨 构建所有包...${NC}"
pnpm build

# 5. Git 提交
echo ""
echo -e "${BLUE}[5/6] 📝 Git 提交...${NC}"

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${GREEN}✅ 没有需要提交的更改${NC}"
else
    echo -e "${YELLOW}📄 发现更改，自动提交...${NC}"
    
    # 检查是否配置了 git 用户
    if ! git config user.name > /dev/null 2>&1; then
        echo -e "${YELLOW}⚙️  配置 git 用户信息...${NC}"
        git config user.name "qfzc"
        git config user.email "qfzc@users.noreply.github.com"
    fi
    
    # 添加所有更改并提交
    git add .
    
    # 尝试提交
    if ! git commit -m "chore: 自动提交 $(date '+%Y-%m-%d %H:%M')" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  提交失败（可能是暂存区为空）${NC}"
    else
        echo -e "${GREEN}✅ 提交成功${NC}"
    fi
fi

# 6. 推送到 GitHub
echo ""
echo -e "${BLUE}[6/6] ⬆️  推送到 GitHub...${NC}"

# 检查远程 URL
REMOTE_URL=$(git remote get-url origin)
echo -e "${YELLOW}📡  远程仓库: $REMOTE_URL${NC}"

# 推送
if git push origin main 2>/dev/null; then
    echo -e "${GREEN}✅ 推送成功！${NC}"
else
    echo -e "${YELLOW}⚠️  推送失败，请检查认证${NC}"
    echo ""
    echo -e "${BLUE}💡 解决方案：${NC}"
    echo "1. 使用 SSH: git remote set-url origin git@github.com:qfzc/tinyflow.git"
    echo "2. 使用 GitHub CLI: gh auth login"
    echo "3. 使用 Personal Access Token"
    exit 1
fi

# 完成
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}✅ 自动化流程完成！${NC}"
echoes "${GREEN}================================${NC}"
echo ""
echo -e "${BLUE}📦 构建的包：${NC}"
echo "  ✅ @tinyflow-ai/ui"
echo "  ✅ @tinyflow-ai/react"
echo "  ✅ @tinyflow-ai/vue"
echo "  ✅ @tinyflow-ai/svelte"
echo ""
echo -e "${BLUE}🔗 GitHub: https://github.com/qfzc/tinyflow${NC}"
echo -e "${BLUE}📥  已推送到 main 分支${NC}"
echo ""
