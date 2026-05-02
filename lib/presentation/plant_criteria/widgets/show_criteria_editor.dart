// lib/presentation/plant_criteria/widgets/criteria_editor.dart
import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';

/// Shows a modal bottom sheet for editing plant care criteria
/// 
/// [context] - BuildContext from the calling page
/// [waterPercent], [lightPercent], [airQualityPercent] - Current values
/// [onSliderChanged] - Callback to update values in parent state
void showCriteriaEditor({
  required BuildContext context,
  required double waterPercent,
  required double lightPercent,
  required double airQualityPercent,
  required Function(double, String) onSliderChanged,
}) {
  // Local copies for real-time UI updates within the modal
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
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Care Criteria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Water Slider
                      _buildSliderCard(
                        title: '💧 Water Level',
                        subtitle: 'Set optimal watering threshold',
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
                          onSliderChanged(v, 'water');  // Update parent
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Light Slider
                      _buildSliderCard(
                        title: '☀️ Light Exposure',
                        subtitle: 'Set ideal light conditions',
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
                      
                      // Air Quality Slider
                      _buildSliderCard(
                        title: '🍃 Air Quality',
                        subtitle: 'Set air quality requirements',
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
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text('Criteria updated! 🌿'),
                                  ],
                                ),
                                backgroundColor: Color(0xFF3A8A1A),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
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
                            'Save Changes',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// Helper: Styled slider card widget
// ─────────────────────────────────────────────────────────────
Widget _buildSliderCard({
  required String title,
  required String subtitle,
  required double value,
  required IconData icon,
  required Color color,
  required String parameter,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Icon + Value
          Row(
            children: [
              AnimatedScale(
                scale: isActive ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                        color: isActive ? color : AppTheme.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? color.withOpacity(0.8) : AppTheme.textMuted,
                      ),
                    ),
                  ],
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
          const SizedBox(height: 16),
          
          // Slider
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
          
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Low', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text('Optimal', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              Text('High', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    ),
  );
}