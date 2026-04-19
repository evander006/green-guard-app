// lib/presentation/plants/pages/plant_criteria_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_guard/presentation/plant_criteria/widgets/bottom_criteria_card.dart';
import 'package:green_guard/presentation/plant_criteria/widgets/temperature_gauge.dart';
import 'package:green_guard/presentation/plant_criteria/widgets/top_bar.dart';

class PlantCriteriaPage extends StatefulWidget {
  final String? imagePath; // ✅ Add this parameter

  const PlantCriteriaPage({super.key, this.imagePath});

  @override
  State<PlantCriteriaPage> createState() => _PlantCriteriaPageState();
}

class _PlantCriteriaPageState extends State<PlantCriteriaPage> {
  late double _waterPercent;
  late double _lightPercent;
  late double _tempPercent;
  late double _airQualityPercent;
  late TextEditingController _nameController;
  late TextEditingController _subtitleController;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _nameController = TextEditingController(text: 'Green');
    _subtitleController = TextEditingController(text: 'Indoor Plant');
  }

  @override
  void dispose() {
    // ✅ Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _initializeValues() {
    _waterPercent = 45.0;
    _lightPercent = 75.0;
    _tempPercent = 22.0;
    _airQualityPercent = 80.0;
  }

  // ✅ Properly closed method
  void _onSliderChanged(double value, String parameter) {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Plant Photo Background
          if (widget.imagePath != null && widget.imagePath!.isNotEmpty)
            Image.file(File(widget.imagePath!), fit: BoxFit.cover)
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.eco, size: 120, color: Colors.white24),
              ),
            ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                buildTopBar(context),
                const SizedBox(height: 16),
                buildTemperatureGauge(_tempPercent),
                const SizedBox(height: 16),
                buildBottomCriteriaCard(
                  context,
                  _waterPercent,
                  _lightPercent,
                  _airQualityPercent,
                  _tempPercent,
                  _onSliderChanged,
                  _nameController,
                  _subtitleController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
