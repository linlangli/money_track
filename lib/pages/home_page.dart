import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/expense_controller.dart';
import '../core/enums/app_enums.dart';
import '../pages/expense_list/expense_list_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../widgets/app_top_navigation_bar.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// 使用 Map 结构管理页面，key 为 BottomNavTab 枚举
  static final Map<BottomNavTab, Widget> pages = {
    BottomNavTab.list: const ExpenseListPage(),
    BottomNavTab.chart: const DashboardPage(),
  };

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());
    Get.put(ExpenseController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopNavigationBar(),
            Expanded(
              child: GetBuilder<NavigationController>(
                builder: (controller) {
                  print("Current tab: ${controller.currentTab}");
                  return pages[controller.currentTab] ?? ExpenseListPage();
                },
              ),
            ),
            GetBuilder<NavigationController>(
              builder: (controller) =>
                  AppBottomNavigationBar(
                    currentTab: controller.currentTab,
                    onTabChanged: controller.changeTab,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
