// ✅ Remove underscores to make functions PUBLIC
import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';

// ✅ PUBLIC: Can be imported from other files
Widget buildBottomCriteriaCard({
  required BuildContext context,
  required double waterPercent,
  required double lightPercent,
  required double airQualityPercent,
  required double tempPercent,
  required Function(double, String) onSliderChanged,
  required TextEditingController nameController,
  required TextEditingController subtitleController,
  required VoidCallback onEditPressed, // ✅ Callback for edit button
}) {
  return Container(
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Plant Name',
            hintStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textMuted,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: subtitleController,
          style: const TextStyle(
            fontSize: 18,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'e.g., Indoor Plant',
            hintStyle: TextStyle(
              fontSize: 18,
              color: AppTheme.textMuted.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: buildMetricCard(
                // ✅ Public function
                icon: Icons.water_drop,
                iconColor: Colors.blue,
                label: 'Water Level',
                value: '${waterPercent.round()}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMetricCard(
                icon: Icons.wb_sunny,
                iconColor: Colors.orange,
                label: 'Light',
                value: '${lightPercent.round()}%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildMetricCard(
                icon: Icons.air,
                iconColor: Colors.green,
                label: 'Air Quality',
                value: '${airQualityPercent.round()}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildMetricCard(
                icon: Icons.thermostat,
                iconColor: Colors.red,
                label: 'Temperature',
                value: '${tempPercent.round()}°C',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onEditPressed, // ✅ Use callback
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A8A1A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Edit Care Criteria',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}

// ✅ PUBLIC metric card widget
Widget buildMetricCard({
  required IconData icon,
  required Color iconColor,
  required String label,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ✅ PUBLIC: Show criteria editor modal
void showCriteriaEditor({
  required BuildContext context,
  required double waterPercent,
  required double lightPercent,
  required double airQualityPercent,
  required Function(double, String) onSliderChanged,
}) {
  // Local copies that live inside the sheet
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
                        setSheetState(() => localWater = v); // updates sheet UI
                        onSliderChanged(v, 'water'); // updates page state
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
