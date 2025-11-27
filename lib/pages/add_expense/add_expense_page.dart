import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/expense_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/expense_model.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExpenseType? _selectedType;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addExpense),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount input
              Text(
                AppStrings.expenseAmount,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: '0.00',
                  prefixText: '¥ ',
                  prefixStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pink,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.amountRequired;
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return AppStrings.amountInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Type selection
              Text(
                AppStrings.expenseType,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _buildTypeSelector(),
              const SizedBox(height: 24),

              // Description input
              Text(
                AppStrings.expenseDescription,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: '请输入消费描述',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.descriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Date selection
              Text(
                AppStrings.expenseDate,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yyyy年MM月dd日 HH:mm').format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  child: const Text(
                    AppStrings.save,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ExpenseType.allTypes.map((type) {
        final isSelected = _selectedType?.id == type.id;
        final color = _getTypeColor(type);

        return InkWell(
          onTap: () {
            setState(() {
              _selectedType = type;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    type.iconPath,
                    colorFilter: ColorFilter.mode(
                      isSelected ? color : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  type.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? color : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getTypeColor(ExpenseType type) {
    switch (type.id) {
      case 'catering':
        return AppColors.catering;
      case 'transportation':
        return AppColors.transportation;
      case 'shopping':
        return AppColors.shopping;
      case 'communication':
        return AppColors.communication;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType == null) {
      Get.snackbar(
        '提示',
        AppStrings.typeRequired,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
      );
      return;
    }

    final expense = Expense(
      type: _selectedType!,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      date: _selectedDate,
    );

    final controller = Get.find<ExpenseController>();
    controller.addExpense(expense);
  }
}

