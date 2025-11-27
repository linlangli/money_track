import 'package:flutter/material.dart';

/// 日历选择器弹窗组件
/// 主题色：FFBD27（金黄色）和 000000（黑色）
/// 符合 Material Design 风格，简约美观
class CustomDatePickerDialog extends StatefulWidget {
  /// 初始选中的日期，默认为今天
  final DateTime? initialDate;

  /// 最早可选日期
  final DateTime? firstDate;

  /// 最晚可选日期
  final DateTime? lastDate;

  /// 日期选择回调
  final Function(DateTime)? onDateSelected;

  const CustomDatePickerDialog({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  /// 显示日历弹窗的静态方法
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  // 主题色
  static const Color primaryColor = Color(0xFFFFBD27);
  static const Color textColor = Color(0xFF000000);
  static const Color subtextColor = Color(0xFF666666);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFEEEEEE);

  late DateTime _currentMonth;
  late DateTime _selectedDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = widget.initialDate ?? now;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _firstDate = widget.firstDate ?? DateTime(1900, 1, 1);
    _lastDate = widget.lastDate ?? DateTime(2100, 12, 31);
  }

  // 获取当前月份的天数
  int _getDaysInMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  // 获取月份第一天是星期几（0=周一, 6=周日）
  int _getFirstDayOfWeek(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    return (firstDay.weekday - 1) % 7;
  }

  // 切换到上一个月
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  // 切换到下一个月
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  // 选择日期
  void _selectDate(DateTime date) {
    if (date.isBefore(_firstDate) || date.isAfter(_lastDate)) {
      return;
    }
    setState(() {
      _selectedDate = date;
    });
  }

  // 确认选择
  void _confirmSelection() {
    widget.onDateSelected?.call(_selectedDate);
    Navigator.of(context).pop(_selectedDate);
  }

  // 格式化月份标题
  String _formatMonthTitle() {
    final months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];
    return '${_currentMonth.year}年 ${months[_currentMonth.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 380 ? 340.0 : screenWidth - 40;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: backgroundColor,
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            _buildHeader(),
            const SizedBox(height: 20),
            // 月份切换栏
            _buildMonthSelector(),
            const SizedBox(height: 16),
            // 星期标题
            _buildWeekdayHeaders(),
            const SizedBox(height: 8),
            // 日期网格
            _buildCalendarGrid(),
            const SizedBox(height: 20),
            // 底部按钮
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // 构建标题栏
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '选择日期',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  // 构建月份切换器
  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: textColor, size: 28),
          onPressed: _previousMonth,
        ),
        Text(
          _formatMonthTitle(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: textColor, size: 28),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  // 构建星期标题
  Widget _buildWeekdayHeaders() {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subtextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 构建日历网格
  Widget _buildCalendarGrid() {
    final daysInMonth = _getDaysInMonth(_currentMonth);
    final firstDayOfWeek = _getFirstDayOfWeek(_currentMonth);
    final totalCells = ((daysInMonth + firstDayOfWeek) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek) {
          return const SizedBox();
        }

        final day = index - firstDayOfWeek + 1;
        if (day > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isSelected = date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;
        final isDisabled = date.isBefore(_firstDate) || date.isAfter(_lastDate);

        return _buildDayCell(date, isSelected, isToday, isDisabled);
      },
    );
  }

  // 构建日期单元格
  Widget _buildDayCell(DateTime date, bool isSelected, bool isToday, bool isDisabled) {
    return GestureDetector(
      onTap: isDisabled ? null : () => _selectDate(date),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: primaryColor, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
              color: isDisabled
                  ? subtextColor.withValues(alpha: 0.3)
                  : isSelected
                      ? textColor
                      : textColor,
            ),
          ),
        ),
      ),
    );
  }

  // 构建底部按钮
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: const BorderSide(color: dividerColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              '取消',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _confirmSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

