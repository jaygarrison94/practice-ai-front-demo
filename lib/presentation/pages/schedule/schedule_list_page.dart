import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../bloc/schedule/schedule_bloc.dart';
import '../../../bloc/schedule/schedule_event.dart';
import '../../../bloc/schedule/schedule_state.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  String _selectedFilter = AppStrings.all;
  String? _selectedCategory;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  final _filters = [AppStrings.all, AppStrings.today, AppStrings.tomorrow, AppStrings.future];
  final _categories = ['全部', '工作', '生活', '重要事项', '其他'];

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(const LoadSchedules());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String keyword) {
    context.read<ScheduleBloc>().add(LoadSchedules(keyword: keyword));
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
    String? date;
    final now = DateTime.now();
    if (filter == AppStrings.today) {
      date = Formatters.formatDate(now);
    } else if (filter == AppStrings.tomorrow) {
      date = Formatters.formatDate(now.add(const Duration(days: 1)));
    }
    context.read<ScheduleBloc>().add(LoadSchedules(
          date: date,
          category: _selectedCategory,
        ));
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category == '全部' ? null : category;
    });
    context.read<ScheduleBloc>().add(LoadSchedules(
          date: _selectedFilter == AppStrings.all ? null : Formatters.formatDate(DateTime.now()),
          category: _selectedCategory,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '搜索日程...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearch,
              )
            : const Text(AppStrings.schedule),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ScheduleBloc>().add(const LoadSchedules());
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/schedule/create'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          _buildCategoryBar(),
          Expanded(child: _buildScheduleList()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => _onFilterChanged(filter),
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = (_selectedCategory ?? '全部') == category;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => _onCategoryChanged(category),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.schedules.isEmpty) {
          return const EmptyState(message: '暂无日程');
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ScheduleBloc>().add(const LoadSchedules());
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.md),
            itemCount: state.schedules.length,
            itemBuilder: (context, index) {
              final schedule = state.schedules[index];
              return Dismissible(
                key: ValueKey(schedule.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppDimensions.md),
                  color: AppColors.expense,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<ScheduleBloc>().add(DeleteSchedule(schedule.id));
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        schedule.scheduleTime,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    title: Text(schedule.title),
                    subtitle: Text(
                      '${schedule.scheduleDate} ${schedule.note ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: schedule.category != null
                        ? Chip(
                            label: Text(
                              schedule.category!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/schedule/${schedule.id}',
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
