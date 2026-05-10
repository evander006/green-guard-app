// lib/presentation/calendar/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';
import 'bloc/calendar_bloc.dart';
import 'bloc/calendar_event.dart';
import 'bloc/calendar_state.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Cache for schedule to avoid recalculating on every build
  Map<DateTime, List<PlantEntity>> _schedule = {};

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule() {
    final firstVisible = _focusedDay.subtract(const Duration(days: 7));
    final lastVisible = _focusedDay.add(const Duration(days: 42));

    context.read<CalendarBloc>().add(
      LoadWateringScheduleRequested(
        startDate: firstVisible,
        endDate: lastVisible,
      ),
    );
  }

  List<PlantEntity> _getPlantsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _schedule[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocConsumer<CalendarBloc, CalendarState>(
                listener: (context, state) {
                  if (state is WateringScheduleLoaded) {
                    setState(() {
                      _schedule = state.schedule;
                    });
                  }
                  if (state is PlantWatered) {
                    _loadSchedule();
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCalendar(state),
                        _buildTodayTasks(state),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A8A1A), Color(0xFF5CB85C)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track your plant care',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              final count = state is WateringScheduleLoaded
                  ? _getPlantsForDay(DateTime.now()).length
                  : 0;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      '$count due today',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(CalendarState state) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (state is CalendarLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            // Replace TableCalendar widget with this:
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day, isSelected: true);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(day, isToday: true);
                },
              ),

              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return _schedule[key] ?? [];
              },

              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppTheme.primary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppTheme.primary,
                ),
              ),

              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                ),
                weekendStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
                _loadSchedule();
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                _loadSchedule();
              },
            ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, 'Due today'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.red, 'Overdue'),
              const SizedBox(width: 16),
              _buildLegendItem(AppTheme.primary, 'Upcoming'),
            ],
          ),
        ],
      ),
    );
  }
  // Add this method to _CalendarPageState:

  Widget _buildCalendarDay(
    DateTime day, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    final plants = _getPlantsForDay(day);

    // Determine marker color based on plant status
    Color? markerColor;
    if (plants.isNotEmpty) {
      final hasOverdue = plants.any((p) => _isOverdue(p, day));
      final hasDueToday = plants.any((p) => _isDueToday(p, day));
      markerColor = hasOverdue
          ? Colors.red
          : (hasDueToday ? Colors.orange : AppTheme.primary);
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primary
            : (isToday
                  ? AppTheme.primary.withOpacity(0.1)
                  : Colors.transparent),
        shape: BoxShape.circle,
        border: isToday && !isSelected
            ? Border.all(color: AppTheme.primary, width: 2)
            : null,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = day;
            _focusedDay = day;
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Day number
              Text(
                '${day.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isToday ? AppTheme.primary : AppTheme.textDark),
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),

              // ✅ Dynamic colored marker dot
              if (markerColor != null) ...[
                const SizedBox(height: 2),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Check if plant is overdue for selected day
  bool _isOverdue(PlantEntity plant, DateTime day) {
    if (plant.reminderTime == null) return false;
    final wateringTime = DateTime(
      day.year,
      day.month,
      day.day,
      plant.reminderTime!.hour,
      plant.reminderTime!.minute,
    );
    return DateTime.now().isAfter(wateringTime) &&
        !DateUtils.isSameDay(day, DateTime.now());
  }

  // ✅ Check if plant is due today
  bool _isDueToday(PlantEntity plant, DateTime day) {
    if (!DateUtils.isSameDay(day, DateTime.now())) return false;
    if (plant.reminderTime == null) return false;
    final wateringTime = DateTime(
      day.year,
      day.month,
      day.day,
      plant.reminderTime!.hour,
      plant.reminderTime!.minute,
    );
    return DateTime.now().isBefore(wateringTime);
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildTodayTasks(CalendarState state) {
    final todayPlants = _getPlantsForDay(_selectedDay);
    final isToday = DateUtils.isSameDay(_selectedDay, DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isToday
                    ? "Today's Tasks"
                    : 'Tasks for ${_formatDate(_selectedDay)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              if (todayPlants.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${todayPlants.length} plants',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (state is CalendarLoading)
            const Center(child: CircularProgressIndicator())
          else if (todayPlants.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayPlants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final plant = todayPlants[index];
                return _buildTaskCard(plant, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No plants need care today 🎉',
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(PlantEntity plant, int index) {
    final isOverdue = _isOverdue(plant, _selectedDay);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? Colors.red.withOpacity(0.3) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              context.read<CalendarBloc>().add(
                MarkPlantWatered(plantId: plant.id, wateredDate: _selectedDay),
              );
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isOverdue ? Colors.red : AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),

          // Plant info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (isOverdue) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Overdue',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: 14,
                      color: isOverdue ? Colors.red : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Water • ${plant.reminderTime?.format(context) ?? "Anytime"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue
                            ? Colors.red.shade700
                            : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isOverdue ? Colors.red : AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showSnoozeOptions(plant),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.snooze,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnoozeOptions(PlantEntity plant) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Snooze reminder for:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Tomorrow'),
              onTap: () {
                Navigator.pop(context);
                // Implement snooze logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Next week'),
              onTap: () {
                Navigator.pop(context);
                // Implement snooze logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
