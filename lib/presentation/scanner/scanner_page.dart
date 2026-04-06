import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/plant_placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  children: [
                    // Top-left corner
                    Positioned(
                      top: 0,
                      left: 0,
                      child: _buildCornerMarker(topLeft: true),
                    ),
                    // Top-right corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _buildCornerMarker(topRight: true),
                    ),
                    // Bottom-left corner
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: _buildCornerMarker(bottomLeft: true),
                    ),
                    // Bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildCornerMarker(bottomRight: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // Bottom plant info card
          // Positioned(
          //   left: 20,
          //   right: 20,
          //   bottom: 40,
          //   child: _buildPlantInfoCard(),
          // ),
        ],
      ),
    );
  }

  Widget _buildCornerMarker({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: CornerMarkerPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }

  // Widget _buildPlantInfoCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppTheme.primary.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         // Plant thumbnail
  //         Container(
  //           width: 60,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             image: const DecorationImage(
  //               image: AssetImage('assets/images/sansevieria_thumb.jpg'),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         // Plant name
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Sansevieria',
  //                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 'Plant',
  //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                       color: Colors.white.withOpacity(0.9),
  //                     ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // Arrow button
  //         Container(
  //           width: 48,
  //           height: 48,
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //           ),
  //           child: IconButton(
  //             icon: const Icon(
  //               Icons.arrow_forward,
  //               color: Color(0xFF3A8A1A),
  //             ),
  //             onPressed: () {
  //               // Navigate to plant details
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class CornerMarkerPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerMarkerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (topLeft) {
      path.moveTo(0, 20);
      path.lineTo(0, 0);
      path.lineTo(20, 0);
    } else if (topRight) {
      path.moveTo(size.width - 20, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, 20);
    } else if (bottomLeft) {
      path.moveTo(0, size.height - 20);
      path.lineTo(0, size.height);
      path.lineTo(20, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width - 20, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - 20);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}