import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/yoga_session_controller.dart';

class YogaSessionScreen extends StatefulWidget {
  const YogaSessionScreen({super.key});

  @override
  State<YogaSessionScreen> createState() => _YogaSessionScreenState();
}

class _YogaSessionScreenState extends State<YogaSessionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final controller = Provider.of<YogaSessionController>(context, listen: false);
          _showExitConfirmation(context, controller);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: Consumer<YogaSessionController>(
          builder: (context, controller, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with session info and controls
                    _buildHeader(controller),
                    
                    const SizedBox(height: 16),
                    
                    // Progress bar
                    _buildProgressBar(controller),
                    
                    const SizedBox(height: 20),
                    
                    // Main content area with image and text
                    Expanded(
                      child: _buildMainContent(controller),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Control buttons
                    _buildControlButtons(controller),
                  ],
                ),
              ),
            );
          },
        ),
      ), // End of Scaffold
    ); // End of PopScope
  }

  Widget _buildHeader(YogaSessionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button with exit confirmation
        IconButton(
          onPressed: () => _showExitConfirmation(context, controller),
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 28,
          ),
        ),
        
        // Session title and timer
        Expanded(
          child: Column(
            children: [
              Text(
                controller.yogaSession?.title ?? 'Yoga Session',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatTime(controller.totalElapsedSeconds)} / ${_formatTime(controller.totalSessionDuration)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // Settings button
        IconButton(
          onPressed: () => _showSessionMenu(context, controller),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(YogaSessionController controller) {
    final progress = controller.totalSessionDuration > 0
        ? controller.totalElapsedSeconds / controller.totalSessionDuration
        : 0.0;
        
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildMainContent(YogaSessionController controller) {
    final currentScript = controller.currentScript;
    final imagePath = controller.currentImagePath;
    
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          
          // Exercise Timer Circle
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                // Background circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Progress circle
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: controller.currentScriptProgress,
                    strokeWidth: 4,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                ),
                // Timer text
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${controller.currentScriptRemainingTime}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'sec',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Pose Image
          if (imagePath != null)
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Added subtle background
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8), // Added padding to ensure full visibility
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain, // Changed from cover to contain
                    errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image: $imagePath',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Current instruction text
          if (currentScript != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    currentScript.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentScript.startSec}s - ${currentScript.endSec}s',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Current sequence info
          if (controller.currentSequence != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.currentSequence!.name.replaceAll('_', ' ').toUpperCase()} (${controller.currentSequenceIndex + 1}/${controller.expandedSequences!.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildControlButtons(YogaSessionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        IconButton(
          onPressed: controller.previousStep,
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 36,
          ),
        ),
        
        // Play/Pause button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              if (controller.isPlaying) {
                controller.pauseSession();
              } else {
                controller.resumeSession();
              }
            },
            icon: Icon(
              controller.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: const Color(0xFF4CAF50),
              size: 64,
            ),
          ),
        ),
        
        // Next button
        IconButton(
          onPressed: controller.nextStep,
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }

  void _showExitConfirmation(BuildContext context, YogaSessionController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B263B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Exit Session?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to exit your yoga session? Your progress will be lost.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Continue Session',
                style: TextStyle(
                  color: Color(0xFF4ECDC4),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                controller.stopSession();
                Navigator.of(context).pop(); // Exit session screen
              },
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSessionMenu(BuildContext context, YogaSessionController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2B47),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              ListTile(
                leading: const Icon(Icons.stop, color: Colors.red),
                title: const Text(
                  'Stop Session',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.stopSession();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
