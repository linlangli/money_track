import 'package:get/get.dart';
import '../core/enums/app_enums.dart';

class NavigationController extends GetxController {
  /// 当前选中的导航索引
  final RxInt selectedIndex = 0.obs;

  /// 切换导航标签（通过索引）
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  /// 切换导航标签（通过枚举）
  void changeTab(BottomNavTab tab) {
    selectedIndex.value = tab.index;
  }

  /// 获取当前选中的标签枚举
  BottomNavTab get currentTab => BottomNavTab.fromIndex(selectedIndex.value);
}

