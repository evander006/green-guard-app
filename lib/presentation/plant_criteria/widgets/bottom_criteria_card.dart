// ✅ Remove unused import
// import 'package:path/path.dart'; // ← Removed
import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';

Widget buildBottomCriteriaCard(
  BuildContext context,
  double waterPercent,
  double lightPercent,
  double airQualityPercent,
  double tempPercent,
  Function(double, String) onSliderChanged,
  TextEditingController nameController,
  TextEditingController subtitleController,
) {
  return SingleChildScrollView(
    child: Container(
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
          // ✅ Editable Plant Name (TextField)
          TextField(
            controller: nameController,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'Plant Name',
              hintStyle: TextStyle(
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

          // ✅ Editable Subtitle (TextField)
          TextField(
            controller: subtitleController,
            style: TextStyle(
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

          // ✅ Vertical Stack: Water, Light, Air (3 cards stacked)
          // Replace the 4 x _buildMetricCard + SizedBox with this:
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                  label: 'Water Level',
                  value: '${waterPercent.round()}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
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
                child: _buildMetricCard(
                  icon: Icons.air,
                  iconColor: Colors.green,
                  label: 'Air Quality',
                  value: '${airQualityPercent.round()}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.thermostat,
                  iconColor: Colors.red,
                  label: 'Temperature',
                  value: '${tempPercent.round()}°C',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Edit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCriteriaEditor(
                  context,
                  waterPercent,
                  lightPercent,
                  airQualityPercent,
                  onSliderChanged,
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
                'Edit Care Criteria',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildMetricCard({
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

void _showCriteriaEditor(
  BuildContext context,
  double waterPercent,
  double lightPercent,
  double airQualityPercent,
  Function(double, String) onSliderChanged,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
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
                // ✅ Only 3 sliders now (no temp)
                _buildSliderCard(
                  title: '💧 Water Level',
                  value: waterPercent,
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  onChanged: (v) => onSliderChanged(v, 'water'),
                ),
                const SizedBox(height: 16),
                _buildSliderCard(
                  title: '☀️ Light Exposure',
                  value: lightPercent,
                  icon: Icons.wb_sunny,
                  color: Colors.orange,
                  onChanged: (v) => onSliderChanged(v, 'light'),
                ),
                const SizedBox(height: 16),
                _buildSliderCard(
                  title: '🍃 Air Quality',
                  value: airQualityPercent,
                  icon: Icons.air,
                  color: Colors.green,
                  onChanged: (v) => onSliderChanged(v, 'air'),
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
    ),
  );
}

Widget _buildSliderCard({
  required String title,
  required double value,
  required IconData icon,
  required Color color,
  required ValueChanged<double> onChanged,
}) {
  return Builder(
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${value.round()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    ),
  );
}
