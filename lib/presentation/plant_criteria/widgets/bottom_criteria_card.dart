// lib/presentation/plant_criteria/widgets/bottom_criteria_card.dart
import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

Widget buildBottomCriteriaCard({
  required BuildContext context,
  required double waterPercent,
  required double lightPercent,
  required double airQualityPercent,
  required double tempPercent,
  required Function(double, String) onSliderChanged,
  required TextEditingController nameController,
  required TextEditingController subtitleController,
  required VoidCallback onEditPressed,
  required String selectedCategory,
  required List<String> categories,
  required Function(String) onCategoryChanged,
  required VoidCallback onSavePressed,
  required bool isSaving,
  required bool reminderEnabled,
  required TimeOfDay? reminderTime,
  required Function(bool) onReminderToggle,
  required Function(TimeOfDay) onReminderTimeChanged,
  required WateringFrequency? frequency,
  required Function(WateringFrequency) onFrequencyChanged,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Plant Name',
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory.isEmpty ? null : selectedCategory,
                  isDense: true,
                  isExpanded: true,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) onCategoryChanged(newValue);
                  },
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                ),
              ),
            ),
          ],
        ),

        TextField(
          controller: subtitleController,
          style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
          decoration: InputDecoration(
            hintText: 'e.g., Indoor Plant',
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted.withOpacity(0.7),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildCompactMetricCard(
                icon: Icons.water_drop,
                iconColor: Colors.blue,
                label: 'Water',
                value: '${waterPercent.round()}%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactMetricCard(
                icon: Icons.wb_sunny,
                iconColor: Colors.orange,
                label: 'Light',
                value: '${lightPercent.round()}%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactMetricCard(
                icon: Icons.air,
                iconColor: Colors.green,
                label: 'Air',
                value: '${airQualityPercent.round()}%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactMetricCard(
                icon: Icons.thermostat,
                iconColor: Colors.red,
                label: 'Temp',
                value: '${tempPercent.round()}°',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onEditPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A8A1A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Edit Criteria',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Watering Reminder',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Toggle: Enable/Disable
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable reminders',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  Switch(
                    value: reminderEnabled,
                    onChanged: (value) => onReminderToggle(value),
                    activeColor: Colors.blue,
                  ),
                ],
              ),

              if (reminderEnabled) ...[
                const SizedBox(height: 12),

                // Time Picker
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime:
                          reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      onReminderTimeChanged(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reminderTime?.format(context) ?? 'Select time',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppTheme.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ Frequency Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<WateringFrequency>(
                          value: frequency,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: AppTheme.textMuted,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textDark,
                          ),
                          items: WateringFrequency.values.map((freq) {
                            return DropdownMenuItem<WateringFrequency>(
                              value: freq,
                              child: Text(_getFrequencyLabel(freq)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              onFrequencyChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSaving ? null : onSavePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A8A1A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            child: isSaving
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Saving...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_alt, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Plant',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCompactMetricCard({
  required IconData icon,
  required Color iconColor,
  required String label,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// In the same file as buildBottomCriteriaCard (or in a utilities file):
String _getFrequencyLabel(WateringFrequency frequency) {
  switch (frequency) {
    case WateringFrequency.daily:
      return 'Every day';
    case WateringFrequency.every2Days:
      return 'Every 2 days';
    case WateringFrequency.every3Days:
      return 'Every 3 days';
    case WateringFrequency.weekly:
      return 'Once a week';
  }
}