import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_track/core/extensions/extensions.dart';
import '../pages/firebase_test_page.dart';

class AppTopNavigationBar extends StatelessWidget {
  const AppTopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/icon_navigation_menu.svg',
          width: 24,
          height: 24,
        ).button(onTap: () {
          // 显示菜单选项
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.bug_report, color: Colors.orange),
                    title: const Text('Firebase 调试'),
                    subtitle: const Text('查看 Firebase 连接状态和测试功能'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const FirebaseTestPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('设置'),
                    subtitle: const Text('开发中...'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.snackbar('提示', '功能开发中...');
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        Spacer(flex: 1),
        Text("钱迹", style: Theme.of(context).textTheme.titleMedium),
        Spacer(flex: 1,),
        SvgPicture.asset(
          'assets/icons/icon_navigation_share.svg',
          width: 24,
          height: 24,
        ).button(onTap: () {

        }),
      ],
    ).paddingOnly(left: 24, right: 24, bottom: 12.h);
  }
}
