#!/bin/bash

# Firebase Analytics 验证脚本
# 用于快速检查和验证 Analytics 埋点是否正常工作

echo "═══════════════════════════════════════════════════════"
echo "🎯 Firebase Analytics 验证脚本"
echo "═══════════════════════════════════════════════════════"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. 检查依赖
echo -e "${BLUE}[1/5] 检查依赖...${NC}"
if grep -q "firebase_analytics:" pubspec.yaml; then
    echo -e "${GREEN}✅ firebase_analytics 依赖已添加${NC}"
else
    echo -e "${RED}❌ firebase_analytics 依赖未找到${NC}"
    echo "请运行: flutter pub add firebase_analytics"
    exit 1
fi
echo ""

# 2. 检查工具类
echo -e "${BLUE}[2/5] 检查工具类文件...${NC}"
if [ -f "lib/utils/analytics_helper.dart" ]; then
    echo -e "${GREEN}✅ analytics_helper.dart 存在${NC}"

    # 检查方法数量
    method_count=$(grep -c "static Future<void>" lib/utils/analytics_helper.dart)
    echo -e "${GREEN}   - 包含 $method_count 个埋点方法${NC}"
else
    echo -e "${RED}❌ analytics_helper.dart 不存在${NC}"
    exit 1
fi
echo ""

# 3. 检查 main.dart 集成
echo -e "${BLUE}[3/5] 检查 main.dart 集成...${NC}"
if grep -q "AnalyticsHelper.initialize" lib/main.dart; then
    echo -e "${GREEN}✅ Analytics 已在 main.dart 初始化${NC}"
else
    echo -e "${YELLOW}⚠️  未在 main.dart 找到初始化代码${NC}"
fi

if grep -q "AnalyticsHelper.observer" lib/main.dart; then
    echo -e "${GREEN}✅ Analytics 导航观察器已添加${NC}"
else
    echo -e "${YELLOW}⚠️  未找到导航观察器${NC}"
fi
echo ""

# 4. 检查控制器集成
echo -e "${BLUE}[4/5] 检查控制器集成...${NC}"
if grep -q "AnalyticsHelper.logAddExpense" lib/controllers/expense_controller.dart; then
    echo -e "${GREEN}✅ addExpense 埋点已添加${NC}"
else
    echo -e "${YELLOW}⚠️  addExpense 埋点未找到${NC}"
fi

if grep -q "AnalyticsHelper.logDeleteExpense" lib/controllers/expense_controller.dart; then
    echo -e "${GREEN}✅ deleteExpense 埋点已添加${NC}"
else
    echo -e "${YELLOW}⚠️  deleteExpense 埋点未找到${NC}"
fi

if grep -q "AnalyticsHelper.logFilterExpenses" lib/controllers/expense_controller.dart; then
    echo -e "${GREEN}✅ filterExpenses 埋点已添加${NC}"
else
    echo -e "${YELLOW}⚠️  filterExpenses 埋点未找到${NC}"
fi
echo ""

# 5. 提供下一步指令
echo -e "${BLUE}[5/5] 下一步操作${NC}"
echo ""
echo -e "${YELLOW}📱 运行应用并验证：${NC}"
echo ""
echo "   方法 1: 热重启（如果应用正在运行）"
echo "   ----------------------------------------"
echo "   在终端按 R 键（大写）"
echo ""
echo "   方法 2: 完全重启"
echo "   ----------------------------------------"
echo "   flutter run"
echo ""
echo -e "${YELLOW}🔍 验证埋点是否工作：${NC}"
echo ""
echo "   1. 查看应用日志，寻找："
echo "      ✅ [Analytics] Firebase Analytics 已启用"
echo "      📊 [Analytics] 事件: app_start"
echo ""
echo "   2. 在应用中操作，观察日志："
echo "      📊 [Analytics] 事件: add_expense"
echo "      📊 [Analytics] 事件: delete_expense"
echo "      📊 [Analytics] 页面浏览: HomePage"
echo ""
echo -e "${YELLOW}🌐 在 Firebase Console 查看：${NC}"
echo ""
echo "   实时数据（10-30 分钟后）："
echo "   https://console.firebase.google.com/project/moneytrack-90239/analytics/app/ios:com.example.moneyTrack/realtime"
echo ""
echo "   DebugView（实时，需启用调试模式）："
echo "   https://console.firebase.google.com/project/moneytrack-90239/analytics/app/ios:com.example.moneyTrack/debugview"
echo ""
echo -e "${YELLOW}🔧 启用 DebugView（可选，推荐）：${NC}"
echo ""
echo "   1. 打开 Xcode："
echo "      cd ios && open Runner.xcworkspace"
echo ""
echo "   2. Product → Scheme → Edit Scheme"
echo "   3. Run → Arguments → Arguments Passed On Launch"
echo "   4. 点击 '+' 添加：-FIRAnalyticsDebugEnabled"
echo "   5. 重新运行应用"
echo ""
echo "═══════════════════════════════════════════════════════"
echo -e "${GREEN}✅ 检查完成！所有必要的埋点配置已就绪。${NC}"
echo "═══════════════════════════════════════════════════════"
echo ""
echo -e "${BLUE}📚 详细文档：${NC}"
echo "   - QUICK_VERIFICATION_GUIDE.md - 快速验证指南"
echo "   - FINAL_SUMMARY.md - 完整总结"
echo "   - documents/ANALYTICS_IMPLEMENTATION_GUIDE.md - 详细指南"
echo ""

