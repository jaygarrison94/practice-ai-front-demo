import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../../data/models/schedule/schedule.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../bloc/schedule/schedule_event.dart';
import '../../bloc/schedule/schedule_state.dart';

class ScheduleFormPage extends StatefulWidget {
  final int? scheduleId;

  const ScheduleFormPage({super.key, this.scheduleId});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _remindBefore = '10分钟';
  String _category = '其他';
  bool _isRepeating = false;
  String _repeatType = 'NONE';
  List<int> _repeatWeekDays = [];
  int? _repeatMonthDate;
  DateTime? _repeatEndDate;

  final _categories = ['工作', '生活', '重要事项', '其他'];
  final _remindOptions = ['5分钟', '10分钟', '30分钟', '1小时', '1天'];
  final _repeatTypes = ['单次', '每日', '每周', '每月'];

  String get _remindBeforeValue {
    switch (_remindBefore) {
      case '5分钟': return '5m';
      case '10分钟': return '10m';
      case '30分钟': return '30m';
      case '1小时': return '1h';
      case '1天': return '1d';
      default: return '10m';
    }
  }

  String? get _repeatTypeValue {
    switch (_repeatType) {
      case 'NONE': return null;
      case '每日': return 'DAILY';
      case '每周': return 'WEEKLY';
      case '每月': return 'MONTHLY';
      default: return null;
    }
  }

  bool get _isEditing => widget.scheduleId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      context.read<ScheduleBloc>().add(LoadScheduleDetail(widget.scheduleId!));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = context.read<ScheduleBloc>().state;
        final schedule = state.selectedSchedule;
        if (schedule != null && schedule.id == widget.scheduleId) {
          _populateForm(schedule);
        }
      });
    }
  }

  void _populateForm(Schedule schedule) {
    setState(() {
      _titleController.text = schedule.title;
      _noteController.text = schedule.note ?? '';
      _selectedDate = DateTime.parse(schedule.scheduleDate);
      _selectedTime = TimeOfDay(
        hour: int.parse(schedule.scheduleTime.split(':')[0]),
        minute: int.parse(schedule.scheduleTime.split(':')[1]),
      );
      _category = schedule.category ?? '其他';
      if (schedule.repeatRule != null) {
        _isRepeating = schedule.repeatRule!.repeatType != 'NONE';
        _repeatType = schedule.repeatRule!.repeatType;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: _selectedTime);
    if (time != null) setState(() => _selectedTime = time);
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) return;

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    if (_isEditing) {
      context.read<ScheduleBloc>().add(UpdateSchedule(
            id: widget.scheduleId!,
            title: _titleController.text,
            date: dateStr,
            time: timeStr,
            remindBefore: _remindBeforeValue,
            note: _noteController.text,
            category: _category,
            repeatType: _repeatTypeValue,
            repeatWeekDays: _repeatWeekDays.join(','),
            repeatMonthDate: _repeatMonthDate,
            repeatEndDate: _repeatEndDate?.toIso8601String(),
          ));
    } else {
      context.read<ScheduleBloc>().add(CreateSchedule(
            title: _titleController.text,
            date: dateStr,
            time: timeStr,
            remindBefore: _remindBeforeValue,
            note: _noteController.text,
            category: _category,
            repeatType: _repeatTypeValue,
            repeatWeekDays: _repeatWeekDays.join(','),
            repeatMonthDate: _repeatMonthDate,
            repeatEndDate: _repeatEndDate?.toIso8601String(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageBlocListener<ScheduleBloc, ScheduleState>(
      popOnSuccess: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? AppStrings.editSchedule : AppStrings.addSchedule),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.scheduleTitle,
                    hintText: '请输入日程标题',
                  ),
                  validator: Validators.validateScheduleTitle,
                ),
                const SizedBox(height: AppDimensions.md),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(AppStrings.scheduleDate),
                  trailing: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  onTap: _pickDate,
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text(AppStrings.scheduleTime),
                  trailing: Text(_selectedTime.format(context)),
                  onTap: _pickTime,
                ),
                const SizedBox(height: AppDimensions.sm),
                DropdownButtonFormField<String>(
                  value: _remindBefore,
                  decoration: const InputDecoration(labelText: AppStrings.remindBefore),
                  items: _remindOptions
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (v) => setState(() => _remindBefore = v ?? '10分钟'),
                ),
                const SizedBox(height: AppDimensions.md),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: AppStrings.scheduleCategory),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? '其他'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.scheduleNote,
                    hintText: '可选',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.md),
                SwitchListTile(
                  title: const Text(AppStrings.repeatReminder),
                  value: _isRepeating,
                  onChanged: (v) => setState(() => _isRepeating = v),
                ),
                if (_isRepeating) ...[
                  DropdownButtonFormField<String>(
                    value: _repeatType == 'NONE' ? '单次' : _repeatType,
                    decoration: const InputDecoration(labelText: '重复类型'),
                    items: _repeatTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _repeatType = v ?? '单次'),
                  ),
                  if (_repeatType == '每周') ...[
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (i) {
                        final days = ['一', '二', '三', '四', '五', '六', '日'];
                        return FilterChip(
                          label: Text(days[i]),
                          selected: _repeatWeekDays.contains(i + 1),
                          onSelected: (s) {
                            setState(() {
                              if (s) {
                                _repeatWeekDays.add(i + 1);
                              } else {
                                _repeatWeekDays.remove(i + 1);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ],
                const SizedBox(height: AppDimensions.xl),
                AppButton(
                  text: _isEditing ? '保存修改' : AppStrings.addSchedule,
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}