import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/navigation/app_routes.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_bloc.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_event.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_state.dart';
import 'dart:io';
import 'package:green_guard/presentation/plant_criteria/widgets/bottom_criteria_card.dart';
import 'package:green_guard/presentation/plant_criteria/widgets/temperature_gauge.dart';
import 'package:green_guard/presentation/plant_criteria/widgets/top_bar.dart';
import 'package:uuid/uuid.dart';

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

  late TextEditingController _nameController;
  late TextEditingController _subtitleController;
  String _selectedCategory = 'Indoor';
  final List<String> _categories = [
    'Indoor',
    'Outdoor',
    'Succulent',
    'Flowering',
    'Fern',
    'Palm',
    'Cactus',
    'Herb',
  ];
  bool _isSaving = false;

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

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

  // lib/presentation/plant_criteria/pages/plant_criteria_page.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ 1. BACKGROUND IMAGE (uncommented and fixed)
          if (widget.imagePath != null && widget.imagePath!.isNotEmpty)
            Positioned.fill(
              child: Image.file(File(widget.imagePath!), fit: BoxFit.cover),
            )
          else
            Positioned.fill(
              child: Container(
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
            ),

          // ✅ 2. GRADIENT OVERLAY (uncommented)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ✅ 3. MAIN CONTENT (with BlocListener)
          BlocListener<PlantBloc, PlantState>(
            listener: (context, state) {
              if (state is PlantSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Plant saved successfully! 🌿'),
                      ],
                    ),
                    backgroundColor: Color(0xFF3A8A1A),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );

                context.go(AppRoutes.home);
              }
              if (state is PlantError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save: ${state.message}'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                setState(() {
                  _isSaving = false;
                });
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    buildTopBar(context),
                    const SizedBox(height: 20),
                    buildTemperatureGauge(_tempPercent),
                    const SizedBox(height: 20),
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
                      selectedCategory: _selectedCategory,
                      categories: _categories,
                      onCategoryChanged: _onCategoryChanged,
                      onSavePressed: _savePlant,
                      isSaving: _isSaving,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ✅ 4. LOADING OVERLAY (when saving)
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 16),
                      const Text(
                        'Saving plant...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openCriteriaEditor() {
    showCriteriaEditor(
      context: context,
      waterPercent: _waterPercent,
      lightPercent: _lightPercent,
      airQualityPercent: _airQualityPercent,
      onSliderChanged: _onSliderChanged,
    );
  }

  Future<void> _savePlant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to save plants'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a plant name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });
    final plantToSave = PlantEntity(
      id: const Uuid().v4(),
      userId: user.uid,
      name: _nameController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      category: _selectedCategory,
      waterPercent: _waterPercent,
      lightPercent: _lightPercent,
      tempPercent: _tempPercent,
      airQualityPercent: _airQualityPercent,
      image: widget.imagePath ?? '',
      createdAt: DateTime.now(),
    );
    if (mounted) {
      context.read<PlantBloc>().add(AddPlantRequested(plant: plantToSave));
    }
  }
}
