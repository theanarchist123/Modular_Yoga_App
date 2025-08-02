import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/yoga_session_controller.dart';
import 'screens/session_selection_screen.dart';
import 'screens/audio_test_screen.dart';
import 'screens/asset_verification_screen.dart';

void main() {
  runApp(const ModularYogaApp());
}

class ModularYogaApp extends StatelessWidget {
  const ModularYogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => YogaSessionController(),
      child: MaterialApp(
        title: 'Modular Yoga Session',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Add some top spacing
              const SizedBox(height: 40),
              // App Title
              const Text(
                'Modular Yoga',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Dynamic Yoga Sessions',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Yoga illustration placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: Colors.white54,
                  size: 80,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Description
              Text(
                'Experience guided yoga sessions that sync perfectly with audio instructions and visual poses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Browse Sessions Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SessionSelectionScreen(),
                      ),
                    );
                  },
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
                      Icon(Icons.library_books, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Browse Yoga Sessions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Info text
              Text(
                'Tap to load the Cat-Cow Flow session',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Debug Audio Test Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AudioTestScreen(),
                    ),
                  );
                },
                child: Text(
                  'Audio Test (Debug)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Asset Verification Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssetVerificationScreen(),
                    ),
                  );
                },
                child: Text(
                  'Asset Verification (Debug)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Add bottom spacing
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
