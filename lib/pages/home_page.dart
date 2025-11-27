import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/expense_controller.dart';
import '../controllers/auth_controller.dart';
import '../pages/expense_list/expense_list_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/profile_page.dart';
import '../widgets/app_top_navigation_bar.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// 使用 Map 结构管理页面，key 为 BottomNavTab 枚举
  static final List<Widget> pages = [
    const ExpenseListPage(),
    const DashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.put(NavigationController());
    final AuthController authController = Get.find<AuthController>();
    Get.put(ExpenseController());

    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            AppTopNavigationBar(),
            Expanded(
              child: Obx(() => pages[navController.selectedIndex.value]),
            ),
            Obx(() => AppBottomNavigationBar(
                  currentTab: navController.currentTab,
                  onTabChanged: (tab) => navController.changeTab(tab),
                )),
          ],
        ),
      ),
    );
  }
}
