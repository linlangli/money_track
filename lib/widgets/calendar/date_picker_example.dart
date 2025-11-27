import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_picker_dialog.dart';

/// 日历组件使用示例页面
class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('日历选择器示例'),
        backgroundColor: const Color(0xFFFFBD27),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 显示选中的日期
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      '已选择日期',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedDate != null
                          ? DateFormat('yyyy年MM月dd日').format(_selectedDate!)
                          : '未选择',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // 选择日期按钮
              ElevatedButton.icon(
                onPressed: _showDatePicker,
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  '选择日期',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFBD27),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 20),
              // 其他示例按钮
              OutlinedButton.icon(
                onPressed: _showDatePickerWithRange,
                icon: const Icon(Icons.date_range),
                label: const Text(
                  '选择日期（限制范围）',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Color(0xFFFFBD27), width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示日历选择器
  void _showDatePicker() async {
    final selectedDate = await CustomDatePickerDialog.show(
      context,
      initialDate: _selectedDate ?? DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  // 显示带日期范围限制的日历选择器
  void _showDatePickerWithRange() async {
    final now = DateTime.now();
    final selectedDate = await CustomDatePickerDialog.show(
      context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, 1), // 本月第一天
      lastDate: DateTime(now.year, now.month + 3, 0), // 三个月后的最后一天
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }
}

