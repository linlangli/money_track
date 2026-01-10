#!/bin/bash

# Firestore 连接快速诊断脚本
# 用于检查网络连接和 Firebase 配置

echo "═══════════════════════════════════════════════════════"
echo "🔥 Firestore 连接诊断脚本"
echo "═══════════════════════════════════════════════════════"
echo ""

# 1. 检查网络连接
echo "🌐 [1/4] 检查网络连接..."
echo ""

if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ 基础网络连接正常"
else
    echo "❌ 网络连接失败 - 无法访问互联网"
    echo "💡 请检查网络设置"
    exit 1
fi

echo ""

# 2. 检查 Firebase/Firestore 连接
echo "🔥 [2/4] 检查 Firebase 服务连接..."
echo ""

# 检查 firebase.googleapis.com
if ping -c 3 firebase.googleapis.com > /dev/null 2>&1; then
    echo "✅ 可以访问 firebase.googleapis.com"
else
    echo "⚠️ 无法 ping firebase.googleapis.com（可能被防火墙阻止）"
fi

# 检查 firestore.googleapis.com
if ping -c 3 firestore.googleapis.com > /dev/null 2>&1; then
    echo "✅ 可以访问 firestore.googleapis.com"
else
    echo "⚠️ 无法 ping firestore.googleapis.com（可能被防火墙阻止）"
fi

# 尝试 HTTP 连接
echo ""
echo "🌐 尝试 HTTPS 连接..."
if curl -s --connect-timeout 5 https://firestore.googleapis.com > /dev/null 2>&1; then
    echo "✅ HTTPS 连接正常"
else
    echo "❌ HTTPS 连接失败"
    echo "💡 可能原因："
    echo "   - 防火墙阻止"
    echo "   - 代理设置问题"
    echo "   - VPN 干扰"
fi

echo ""

# 3. 检查 Flutter 环境
echo "📱 [3/4] 检查 Flutter 环境..."
echo ""

if command -v flutter &> /dev/null; then
    flutter_version=$(flutter --version 2>&1 | head -n 1)
    echo "✅ Flutter 已安装: $flutter_version"
else
    echo "❌ Flutter 未安装或不在 PATH 中"
fi

echo ""

# 4. 检查项目配置
echo "🔧 [4/4] 检查项目配置..."
echo ""

# 检查 Firebase 配置文件
if [ -f "lib/firebase_options.dart" ]; then
    echo "✅ firebase_options.dart 存在"

    # 检查项目 ID
    if grep -q "moneytrack-90239" lib/firebase_options.dart; then
        echo "✅ 项目 ID 正确: moneytrack-90239"
    else
        echo "⚠️ 项目 ID 可能不正确"
    fi
else
    echo "❌ firebase_options.dart 不存在"
    echo "💡 运行: flutterfire configure"
fi

# 检查 iOS 配置
if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "✅ iOS GoogleService-Info.plist 存在"
else
    echo "⚠️ iOS GoogleService-Info.plist 不存在"
fi

# 检查 Android 配置
if [ -f "android/app/google-services.json" ]; then
    echo "✅ Android google-services.json 存在"
else
    echo "⚠️ Android google-services.json 不存在"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "📊 诊断结果总结"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "如果所有检查都通过，但应用仍然卡住，最可能的原因是："
echo ""
echo "🎯 Firestore 安全规则限制了访问"
echo ""
echo "解决方案："
echo "1. 打开 Firebase Console:"
echo "   https://console.firebase.google.com/project/moneytrack-90239/firestore"
echo ""
echo "2. 点击 '规则' 标签"
echo ""
echo "3. 设置为测试模式（仅用于开发）："
echo ""
echo "   rules_version = '2';"
echo "   service cloud.firestore {"
echo "     match /databases/{database}/documents {"
echo "       match /{document=**} {"
echo "         allow read, write: if true;"
echo "       }"
echo "     }"
echo "   }"
echo ""
echo "4. 点击 '发布'"
echo ""
echo "5. 重启应用（在终端按 R）"
echo ""
echo "═══════════════════════════════════════════════════════"

