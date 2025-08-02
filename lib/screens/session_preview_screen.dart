import 'package:flutter/material.dart';
import '../models/yoga_session.dart';

class SessionPreviewScreen extends StatelessWidget {
  final YogaSession yogaSession;
  final VoidCallback onStartSession;

  const SessionPreviewScreen({
    super.key,
    required this.yogaSession,
    required this.onStartSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B47),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          yogaSession.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // More balanced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    yogaSession.category.toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    yogaSession.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Description
                  if (yogaSession.description != null) ...[
                    Text(
                      yogaSession.description!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.loop,
                        '${yogaSession.defaultLoopCount} cycles',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.timer,
                        yogaSession.tempo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Benefits Section
            if (yogaSession.benefits != null && yogaSession.benefits!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7FB069).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7FB069).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          color: const Color(0xFF7FB069),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Benefits',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...yogaSession.benefits!.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7FB069),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Poses Preview
            const Text(
              'Session Flow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              height: 200, // Reduced height to bring button up
              child: ListView.builder(
                itemCount: yogaSession.sequence.length,
                itemBuilder: (context, index) {
                  final sequence = yogaSession.sequence[index];
                  return _buildSequenceCard(sequence, index);
                },
              ),
            ),
            
            // Start Button - moved closer
            const SizedBox(height: 16), // Reduced spacing
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: onStartSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Start Session',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSequenceCard(YogaSequence sequence, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Reduced margin
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Sequence Number
          Container(
            width: 32, // Smaller size
            height: 32,
            decoration: BoxDecoration(
              color: sequence.type == 'loop' 
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: sequence.type == 'loop'
                  ? const Icon(Icons.loop, color: Colors.orange, size: 16)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Sequence Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sequence.name.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12, // Smaller font
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${sequence.durationSec}s ${sequence.type == 'loop' ? '× ${yogaSession.defaultLoopCount}' : ''}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10, // Smaller font
                  ),
                ),
              ],
            ),
          ),
          
          // Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Smaller padding
            decoration: BoxDecoration(
              color: sequence.type == 'loop' 
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              sequence.type.toUpperCase(),
              style: TextStyle(
                color: sequence.type == 'loop' ? Colors.orange : Colors.green,
                fontSize: 8, // Smaller font
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
