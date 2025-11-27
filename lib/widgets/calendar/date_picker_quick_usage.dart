import 'package:flutter/material.dart';

import 'date_picker_dialog.dart';

/// 快速使用示例 - 在任何地方调用日历选择器
class QuickUsageExample {

  /// 示例1: 基础使用
  static Future<void> example1(BuildContext context) async {
    final selectedDate = await CustomDatePickerDialog.show(context);

    if (selectedDate != null) {
      print('选中的日期: $selectedDate');
    }
  }

  /// 示例2: 设置初始日期
  static Future<void> example2(BuildContext context) async {
    final selectedDate = await CustomDatePickerDialog.show(
      context,
      initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
      print('选中的日期: $selectedDate');
    }
  }

  /// 示例3: 限制日期范围（只能选择未来30天）
  static Future<void> example3(BuildContext context) async {
    final now = DateTime.now();

    final selectedDate = await CustomDatePickerDialog.show(
      context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      print('选中的日期: $selectedDate');
    }
  }

  /// 示例4: 只能选择本月日期
  static Future<void> example4(BuildContext context) async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final selectedDate = await CustomDatePickerDialog.show(
      context,
      initialDate: now,
      firstDate: firstDayOfMonth,
      lastDate: lastDayOfMonth,
    );

    if (selectedDate != null) {
      print('选中的日期: $selectedDate');
    }
  }

  /// 示例5: 在表单中使用
  static Widget formFieldExample() {
    DateTime? selectedDate;

    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () async {
            final date = await CustomDatePickerDialog.show(
              context,
              initialDate: selectedDate ?? DateTime.now(),
            );

            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: '选择日期',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              selectedDate != null
                  ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                  : '请选择日期',
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  /// 示例6: 旅行日期选择（选择出发日期，返程日期必须晚于出发日期）
  static Widget travelDateExample() {
    DateTime? departureDate;
    DateTime? returnDate;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            // 出发日期
            ListTile(
              leading: const Icon(Icons.flight_takeoff, color: Color(0xFFFFBD27)),
              title: const Text('出发日期'),
              subtitle: Text(
                departureDate != null
                    ? '${departureDate!.year}年${departureDate!.month}月${departureDate!.day}日'
                    : '请选择出发日期',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await CustomDatePickerDialog.show(
                  context,
                  initialDate: departureDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (date != null) {
                  setState(() {
                    departureDate = date;
                    // 如果返程日期早于出发日期，清空返程日期
                    if (returnDate != null && returnDate!.isBefore(date)) {
                      returnDate = null;
                    }
                  });
                }
              },
            ),

            const Divider(),

            // 返程日期
            ListTile(
              leading: const Icon(Icons.flight_land, color: Color(0xFFFFBD27)),
              title: const Text('返程日期'),
              subtitle: Text(
                returnDate != null
                    ? '${returnDate!.year}年${returnDate!.month}月${returnDate!.day}日'
                    : '请选择返程日期',
              ),
              trailing: const Icon(Icons.chevron_right),
              enabled: departureDate != null,
              onTap: departureDate == null ? null : () async {
                final date = await CustomDatePickerDialog.show(
                  context,
                  initialDate: returnDate ?? departureDate!.add(const Duration(days: 1)),
                  firstDate: departureDate!.add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (date != null) {
                  setState(() {
                    returnDate = date;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}

