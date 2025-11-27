import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_track/core/enums/app_enums.dart';
import 'package:money_track/core/extensions/extensions.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final BottomNavTab currentTab;
  final ValueChanged<BottomNavTab> onTabChanged;

  const AppBottomNavigationBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            currentTab == BottomNavTab.list
                ? 'assets/icons/icon_navigation_expend_list_selected.svg'
                : 'assets/icons/icon_navigation_expend_list.svg',
            width: 32,
            height: 32,
          ).button(onTap: () {
            onTabChanged(BottomNavTab.list);
            print("🚗");
          }),
          SvgPicture.asset(
            'assets/icons/icon_navigation_add.svg',
            width: 44,
            height: 44,
          ).button(onTap: () {
          }).marginOnly(bottom: 24),
          SvgPicture.asset(
            currentTab == BottomNavTab.chart
                ? 'assets/icons/icon_navigation_expend_chart_selected.svg'
                : 'assets/icons/icon_navigation_expend_chart.svg',
            width: 32,
            height: 32,
          ).button(onTap: () {
            onTabChanged(BottomNavTab.chart);
          }),
        ],
      ).paddingHorizontal(24),
    );
  }

}