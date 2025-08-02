import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/yoga_session_controller.dart';
import '../services/dynamic_yoga_session_service.dart';
import 'session_preview_screen.dart';
import 'yoga_session_screen.dart';

class SessionSelectionScreen extends StatefulWidget {
  const SessionSelectionScreen({super.key});

  @override
  State<SessionSelectionScreen> createState() => _SessionSelectionScreenState();
}

class _SessionSelectionScreenState extends State<SessionSelectionScreen> {
  List<YogaSessionMeta> _availableSessions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAvailableSessions();
  }

  Future<void> _loadAvailableSessions() async {
    try {
      final sessions = await DynamicYogaSessionService.getAvailableSessions();
      setState(() {
        _availableSessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text(
          'Select Yoga Session',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load sessions',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadAvailableSessions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _availableSessions.isEmpty
                  ? const Center(
                      child: Text(
                        'No yoga sessions found',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _availableSessions.length,
                      itemBuilder: (context, index) {
                        final session = _availableSessions[index];
                        return _buildSessionCard(session);
                      },
                    ),
    );
  }

  Widget _buildSessionCard(YogaSessionMeta session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xFF1B263B),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _loadSession(session),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      session.category.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white.withOpacity(0.7),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                session.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              
              // Add description for Cat-Cow specifically
              if (session.title.toLowerCase().contains('cat-cow'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'A gentle, flowing movement that creates mobility and awareness through the entire spine while coordinating breath with movement.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              
              Row(
                children: [
                  Icon(
                    Icons.loop,
                    color: Colors.white.withOpacity(0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${session.defaultLoopCount} cycles',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.speed,
                    color: Colors.white.withOpacity(0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session.tempo,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSession(YogaSessionMeta sessionMeta) async {
    try {
      final controller = Provider.of<YogaSessionController>(context, listen: false);
      await controller.loadSession(sessionMeta.filePath);
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionPreviewScreen(
              yogaSession: controller.yogaSession!,
              onStartSession: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YogaSessionScreen(),
                  ),
                );
                controller.startSession();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
