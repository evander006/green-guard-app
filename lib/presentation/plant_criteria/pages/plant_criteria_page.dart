import 'package:flutter/material.dart';
import 'dart:io';
import 'package:green_guard/presentation/plant_criteria/widgets/bottom_criteria_card.dart';
// ✅ Import the public helpers

class PlantCriteriaPage extends StatefulWidget {
  final String? imagePath;

  const PlantCriteriaPage({super.key, this.imagePath});

  @override
  State<PlantCriteriaPage> createState() => _PlantCriteriaPageState();
}

class _PlantCriteriaPageState extends State<PlantCriteriaPage> {
  late double _waterPercent;
  late double _lightPercent;
  late double _tempPercent;
  late double _airQualityPercent;

  // ✅ Track which slider is being dragged
  String? _draggingSlider;

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

  // ✅ Drag callbacks for visual feedback
  void _onSliderDragStart(String parameter) {
    setState(() => _draggingSlider = parameter);
  }

  void _onSliderDragEnd(String parameter) {
    setState(() => _draggingSlider = null);
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

          // Gradient Overlay
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const Spacer(),
                _buildTemperatureGauge(_tempPercent),
                const SizedBox(height: 16),
                buildBottomCriteriaCard(
                  context: context,
                  waterPercent: _waterPercent,
                  lightPercent: _lightPercent,
                  airQualityPercent: _airQualityPercent,
                  tempPercent: _tempPercent,
                  onSliderChanged: _onSliderChanged,
                  nameController: _nameController,
                  subtitleController: _subtitleController,
                  onEditPressed: _openCriteriaEditor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCriteriaEditor() {
    // ✅ Call public helper with all state
    showCriteriaEditor(
      context: context,
      waterPercent: _waterPercent,
      lightPercent: _lightPercent,
      airQualityPercent: _airQualityPercent,
      onSliderChanged: _onSliderChanged,
   
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureGauge(double tempPercent) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF2196F3),
                    Color(0xFF4CAF50),
                    Color(0xFFFFEB3B),
                    Color(0xFFFF9800),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: tempPercent * 2,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${tempPercent.round()}°',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A8A1A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
