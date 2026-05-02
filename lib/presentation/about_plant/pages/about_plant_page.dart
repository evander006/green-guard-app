// lib/presentation/plants/pages/plant_details_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:green_guard/domain/entities/plant_entity.dart';

class PlantDetailsPage extends StatelessWidget {
  final PlantEntity plant;

  const PlantDetailsPage({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D5A3F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ 1. Plant Image Background
          Positioned.fill(
            child: plant.image.isNotEmpty && File(plant.image).existsSync()
                ? Image.file(
                    File(plant.image),
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2D5A3F), Color(0xFF4A7C59)],
                      ),
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 200,
                      color: Colors.white10,
                    ),
                  ),
          ),

          // ✅ 2. Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xFF2D5A3F).withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ✅ 3. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(context),
                const Spacer(),

                // Plant Info (Top Right)
                _buildPlantInfo(),
                const SizedBox(height: 40),

                // Bottom Card
                _buildBottomCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/root/home'),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'My plants',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Toggle Switch
          
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Plant Name & Stats (Top Right)
  // ─────────────────────────────────────────────────────────────
  Widget _buildPlantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Plant Name
          Text(
            plant.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          // Plant Age/Category
          Text(
            plant.category,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // Stats
          _buildStatRow(
            icon: Icons.water_drop,
            value: '${plant.waterPercent.toInt()}%',
            label: 'Humidity',
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            icon: Icons.grass,
            value: '${plant.lightPercent.toInt()}%',
            label: 'Fertilizer',
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            icon: Icons.schedule,
            value: '36 min',
            label: 'Next watering',
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Bottom Card with Metrics
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9F6),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Alert Banner
          Row(
            children: [
              // Plant Thumbnail
                            // Alert Message
              
            ],
          ),
          const SizedBox(height: 24),

          // Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetric(
                value: '${plant.waterPercent.toInt()}%',
                label: 'Water Tank',
                icon: Icons.water_drop,
                color: plant.waterPercent < 20 ? Colors.red : Colors.blue,
                showLowIndicator: plant.waterPercent < 20,
              ),
              _buildMetric(
                value: '${plant.lightPercent.toInt()}%',
                label: 'Light',
                icon: Icons.wb_sunny,
                color: Colors.orange,
              ),
              _buildMetric(
                value: '${plant.tempPercent.toInt()}°C',
                label: 'Temper.',
                icon: Icons.thermostat,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),          
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    bool showLowIndicator = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLowIndicator)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}