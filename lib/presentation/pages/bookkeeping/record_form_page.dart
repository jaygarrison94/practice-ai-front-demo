import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_picker_tile.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../../data/models/bookkeeping/record.dart' as bookkeeping_model;
import '../../bloc/bookkeeping/bookkeeping_bloc.dart';
import '../../bloc/bookkeeping/bookkeeping_event.dart';
import '../../bloc/bookkeeping/bookkeeping_state.dart';

class RecordFormPage extends StatefulWidget {
  final int? recordId;

  const RecordFormPage({super.key, this.recordId});

  @override
  State<RecordFormPage> createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int _type = 1;
  String _category = '其他';
  DateTime _recordDate = DateTime.now();

  final _expenseCategories = ['餐饮', '交通', '购物', '房租', '其他'];
  final _incomeCategories = ['工资', '兼职', '理财', '其他'];

  bool get _isEditing => widget.recordId != null;

  List<String> get _categories =>
      _type == 1 ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      context.read<BookkeepingBloc>().add(LoadRecordDetail(widget.recordId!));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _populateForm(bookkeeping_model.Record record) {
    setState(() {
      _type = record.type;
      _category = record.categoryName ?? '其他';
      _recordDate = DateTime.parse(record.recordDate);
      _amountController.text = record.amount.toString();
      _noteController.text = record.note ?? '';
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    final dateStr = DateFormat('yyyy-MM-dd').format(_recordDate);

    if (_isEditing) {
      context.read<BookkeepingBloc>().add(UpdateRecord(
            id: widget.recordId!,
            type: _type,
            amount: amount,
            categoryName: _category,
            note: _noteController.text,
            recordDate: dateStr,
          ));
    } else {
      context.read<BookkeepingBloc>().add(CreateRecord(
            type: _type,
            amount: amount,
            categoryName: _category,
            note: _noteController.text,
            recordDate: dateStr,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookkeepingBloc, BookkeepingState>(
      listenWhen: (previous, current) =>
          previous.selectedRecord != current.selectedRecord,
      listener: (context, state) {
        final record = state.selectedRecord;
        if (record != null && record.id == widget.recordId) {
          _populateForm(record);
        }
      },
      child: MessageBlocListener<BookkeepingBloc, BookkeepingState>(
        popOnSuccess: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? AppStrings.editRecord : AppStrings.addRecord),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _TypeToggle(
                          label: AppStrings.expense,
                          isSelected: _type == 1,
                          color: AppColors.expense,
                          onTap: () => setState(() => _type = 1),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: _TypeToggle(
                          label: AppStrings.income,
                          isSelected: _type == 2,
                          color: AppColors.income,
                          onTap: () => setState(() => _type = 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    controller: _amountController,
                    labelText: AppStrings.amount,
                    hintText: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: Validators.validateAmount,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  const Text(
                    AppStrings.category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((c) {
                      return ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (s) {
                          if (s) setState(() => _category = c);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  AppTextField(
                    controller: _noteController,
                    labelText: AppStrings.bookkeepingNote,
                    hintText: '可选',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppDimensions.md),
                AppPickerTile(
                  icon: Icons.calendar_today,
                  label: AppStrings.recordDate,
                  value: DateFormat('yyyy-MM-dd').format(_recordDate),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _recordDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _recordDate = date);
                  },
                ),
                  const SizedBox(height: AppDimensions.xl),
                  BlocBuilder<BookkeepingBloc, BookkeepingState>(
                    builder: (context, state) {
                      return AppButton(
                        text: _isEditing ? '保存修改' : AppStrings.addRecord,
                        isLoading: state.isLoading,
                        onPressed: _onSave,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeToggle({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.backgroundLight,
            border: Border(
              top: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
              left: BorderSide(color: AppColors.borderLight, width: AppDimensions.pixelBorder),
              right: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
              bottom: BorderSide(color: AppColors.borderDark, width: AppDimensions.pixelBorder),
            ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
