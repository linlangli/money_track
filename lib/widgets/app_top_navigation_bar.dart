import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_track/core/extensions/extensions.dart';

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
