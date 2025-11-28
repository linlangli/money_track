import 'package:get/get.dart';
import '../core/enums/app_enums.dart';

class NavigationController extends GetxController {
  /// 当前选中的导航标签
  BottomNavTab _currentTab = BottomNavTab.list;

  /// 获取当前选中的标签枚举
  BottomNavTab get currentTab => _currentTab;

  /// 获取当前选中的导航索引
  int get selectedIndex => _currentTab.index;

  /// 切换导航标签（通过索引）
  void changeIndex(int index) {
    final tab = BottomNavTab.fromIndex(index);
    if (_currentTab != tab) {
      _currentTab = tab;
      update();
    }
  }

  /// 切换导航标签（通过枚举）
  void changeTab(BottomNavTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      update();
    }
  }
}

