import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';

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
            // ✅ Compact dropdown
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
          style: const TextStyle(
            fontSize: 14, // ✅ Reduced from 18
            color: AppTheme.textMuted,
          ),
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

// ✅ New compact metric card widget
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
        Icon(icon, color: iconColor, size: 20), // ✅ Smaller icon
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14, // ✅ Reduced from 18
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10, // ✅ Reduced from 12
            color: AppTheme.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

void showCriteriaEditor({
  required BuildContext context,
  required double waterPercent,
  required double lightPercent,
  required double airQualityPercent,
  required Function(double, String) onSliderChanged,
}) {
  double localWater = waterPercent;
  double localLight = lightPercent;
  double localAir = airQualityPercent;
  String? draggingSlider;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    buildSliderCard(
                      title: '💧 Water Level',
                      value: localWater,
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      parameter: 'water',
                      isActive: draggingSlider == 'water',
                      onDragStart: () =>
                          setSheetState(() => draggingSlider = 'water'),
                      onDragEnd: () =>
                          setSheetState(() => draggingSlider = null),
                      onChanged: (v) {
                        setSheetState(() => localWater = v);
                        onSliderChanged(v, 'water');
                      },
                    ),
                    const SizedBox(height: 16),
                    buildSliderCard(
                      title: '☀️ Light Exposure',
                      value: localLight,
                      icon: Icons.wb_sunny,
                      color: Colors.orange,
                      parameter: 'light',
                      isActive: draggingSlider == 'light',
                      onDragStart: () =>
                          setSheetState(() => draggingSlider = 'light'),
                      onDragEnd: () =>
                          setSheetState(() => draggingSlider = null),
                      onChanged: (v) {
                        setSheetState(() => localLight = v);
                        onSliderChanged(v, 'light');
                      },
                    ),
                    const SizedBox(height: 16),
                    buildSliderCard(
                      title: '🍃 Air Quality',
                      value: localAir,
                      icon: Icons.air,
                      color: Colors.green,
                      parameter: 'air',
                      isActive: draggingSlider == 'air',
                      onDragStart: () =>
                          setSheetState(() => draggingSlider = 'air'),
                      onDragEnd: () =>
                          setSheetState(() => draggingSlider = null),
                      onChanged: (v) {
                        setSheetState(() => localAir = v);
                        onSliderChanged(v, 'air');
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Criteria saved! 🌿'),
                              backgroundColor: Color(0xFF3A8A1A),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A8A1A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget buildSliderCard({
  required String title,
  required double value,
  required IconData icon,
  required Color color,
  required String parameter, // ✅ Required for tracking
  required ValueChanged<double> onChanged,
  VoidCallback? onDragStart,
  VoidCallback? onDragEnd,
  bool isActive = false,
}) {
  return Builder(
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: color, width: 2) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedScale(
                scale: isActive ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? color : AppTheme.textDark,
                  ),
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: isActive ? 18 : 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                child: Text('${value.round()}%'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: isActive ? Colors.white : color,
              overlayColor: color.withOpacity(0.1),
              trackHeight: isActive ? 8 : 6,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: isActive ? 14 : 12,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
              onChangeStart: (_) => onDragStart?.call(),
              onChangeEnd: (_) => onDragEnd?.call(),
            ),
          ),
        ],
      ),
    ),
  );
}
