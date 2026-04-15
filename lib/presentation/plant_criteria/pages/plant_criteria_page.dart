// lib/presentation/plants/pages/plant_criteria_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';


class PlantCriteriaPage extends StatefulWidget {
  final PlantEntity? plant; // null for global defaults, plant for specific
  
  const PlantCriteriaPage({
    super.key,
    this.plant,
  });

  @override
  State<PlantCriteriaPage> createState() => _PlantCriteriaPageState();
}

class _PlantCriteriaPageState extends State<PlantCriteriaPage> {
  late double _waterPercent;
  late double _lightPercent;
  late double _tempPercent;
  late double _airQualityPercent;
  
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    if (widget.plant != null) {
      // Use plant-specific values
      _waterPercent = widget.plant!.waterPercent;
      _lightPercent = widget.plant!.lightPercent;
      _tempPercent = widget.plant!.tempPercent;
      _airQualityPercent = widget.plant!.airQualityPercent;
    } else {
      // Use default values
      _waterPercent = 50.0;
      _lightPercent = 50.0;
      _tempPercent = 50.0;
      _airQualityPercent = 50.0;
    }
  }

  void _onSliderChanged(double value, String parameter) {
    setState(() {
      _hasChanges = true;
      switch (parameter) {
        case 'water':
          _waterPercent = value;
          break;
        case 'light':
          _lightPercent = value;
          break;
        case 'temp':
          _tempPercent = value;
          break;
        case 'air':
          _airQualityPercent = value;
          break;
      }
    });
  }

  // void _saveCriteria() {
  //   if (widget.plant != null) {
  //     // Save plant-specific criteria
  //     context.read<PlantCriteriaBloc>().add(
  //       UpdatePlantCriteria(
  //         plantId: widget.plant!.id,
  //         waterPercent: _waterPercent,
  //         lightPercent: _lightPercent,
  //         tempPercent: _tempPercent,
  //         airQualityPercent: _airQualityPercent,
  //       ),
  //     );
  //   } else {
  //     // Save global default criteria
  //     context.read<PlantCriteriaBloc>().add(
  //       UpdateGlobalCriteria(
  //         waterPercent: _waterPercent,
  //         lightPercent: _lightPercent,
  //         tempPercent: _tempPercent,
  //         airQualityPercent: _airQualityPercent,
  //       ),
  //     );
  //   }
    
  //   setState(() => _hasChanges = false);
    
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Criteria saved successfully! 🌿'),
  //       backgroundColor: Color(0xFF3A8A1A),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('Are you sure you want to reset all criteria to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _waterPercent = 50.0;
                _lightPercent = 50.0;
                _tempPercent = 50.0;
                _airQualityPercent = 50.0;
                _hasChanges = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () {
            if (_hasChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          widget.plant != null 
              ? '${widget.plant!.name} - Care Criteria'
              : 'Default Care Criteria',
          style: const TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: () {
                
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF3A8A1A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
       
          // Scrollable criteria list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCriteriaCard(
                    title: '💧 Water Level',
                    subtitle: 'Set optimal watering threshold',
                    icon: Icons.water_drop,
                    iconColor: Colors.blue,
                    value: _waterPercent,
                    onChanged: (value) => _onSliderChanged(value, 'water'),
                    unit: '%',
                  ),
                  const SizedBox(height: 16),
                  _buildCriteriaCard(
                    title: '☀️ Light Exposure',
                    subtitle: 'Set ideal light conditions',
                    icon: Icons.wb_sunny,
                    iconColor: Colors.orange,
                    value: _lightPercent,
                    onChanged: (value) => _onSliderChanged(value, 'light'),
                    unit: '%',
                  ),
                  const SizedBox(height: 16),
                  _buildCriteriaCard(
                    title: '🌡️ Temperature',
                    subtitle: 'Set comfortable temperature range',
                    icon: Icons.thermostat,
                    iconColor: Colors.red,
                    value: _tempPercent,
                    onChanged: (value) => _onSliderChanged(value, 'temp'),
                    unit: '%',
                  ),
                  const SizedBox(height: 16),
                  _buildCriteriaCard(
                    title: '🍃 Air Quality',
                    subtitle: 'Set air quality requirements',
                    icon: Icons.air,
                    iconColor: Colors.green,
                    value: _airQualityPercent,
                    onChanged: (value) => _onSliderChanged(value, 'air'),
                    unit: '%',
                  ),
                  const SizedBox(height: 32),
                  
                  // Reset button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _resetToDefaults,
                      icon: const Icon(Icons.restore, color: AppTheme.textMuted),
                      label: const Text(
                        'Reset to Defaults',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE0E8E0)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Save button (sticky at bottom)
          if (_hasChanges)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    
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
                    'Save Criteria',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  

  Widget _buildCriteriaCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double value,
    required ValueChanged<double> onChanged,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${value.round()}$unit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: iconColor,
              inactiveTrackColor: iconColor.withOpacity(0.2),
              thumbColor: iconColor,
              overlayColor: iconColor.withOpacity(0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Optimal',
                style: TextStyle(
                  fontSize: 12,
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'High',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF3A8A1A)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}