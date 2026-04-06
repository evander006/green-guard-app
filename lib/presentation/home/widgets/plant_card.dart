// lib/presentation/home/widgets/plant_card.dart
import 'package:flutter/material.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';


class PlantCardWidget extends StatelessWidget {
  final PlantEntity plant;
  final bool isGreen;

  const PlantCardWidget({
    super.key,
    required this.plant,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isGreen ? AppTheme.primary : Colors.white;
    final textColor = isGreen ? Colors.white : AppTheme.textDark;
    final subColor = isGreen ? Colors.white70 : AppTheme.textMuted;
    final statColor = isGreen ? Colors.white : AppTheme.textDark;
    final statLabelColor = isGreen ? Colors.white70 : AppTheme.textMuted;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isGreen ? AppTheme.primary : Colors.black)
                .withOpacity(isGreen ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isGreen)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFF2D1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✦ Featured',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3A8A1A),
                          ),
                        ),
                      ),
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.3,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      plant.subtitle,
                      style: TextStyle(fontSize: 14, color: subColor),
                    ),
                  ],
                ),
              ),
              _arrowButton(isGreen),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _stat('${plant.waterPercent.toInt()}%', 'Water',
                  statColor, statLabelColor),
              const SizedBox(width: 20),
              _stat('${plant.lightPercent.toInt()}%', 'Lights',
                  statColor, statLabelColor),
              const Spacer(),
              Text(
                plant.imageEmoji,
                style: const TextStyle(fontSize: 80, height: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label, Color valColor, Color lblColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: valColor)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: lblColor)),
      ],
    );
  }

  Widget _arrowButton(bool isGreen) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isGreen ? Colors.white.withOpacity(0.25) : AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_outward_rounded,
        size: 18,
        color: isGreen ? Colors.white : Colors.white,
      ),
    );
  }
}
