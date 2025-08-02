import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/yoga_session_controller.dart';
import 'screens/session_selection_screen.dart';

void main() {
  runApp(const YogaVidyaApp());
}

class YogaVidyaApp extends StatelessWidget {
  const YogaVidyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => YogaSessionController(),
      child: MaterialApp(
        title: 'YogaVidya - Mindful Movement',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity,
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutBack,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _logoAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF0D1B2A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Animated Logo Section
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF7FB069),
                                Color(0xFF8FBC8F),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7FB069).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/YogaVidya.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.self_improvement,
                                  color: Colors.white,
                                  size: 80,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // App Name and Tagline
                AnimatedBuilder(
                  animation: _logoAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Column(
                        children: [
                          const Text(
                            'YogaVidya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transform Through Ancient Wisdom, Flow With Modern Grace',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF7FB069),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
                
                // Main Content Card
                SlideTransition(
                  position: _cardSlideAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20), // Reduced from 28 to 20
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF7FB069).withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Welcome Message
                        const Text(
                          'Begin Your Journey',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          'Experience guided yoga sessions that sync perfectly with audio instructions and visual poses. Transform your practice with personalized flows designed for modern practitioners.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15, // Reduced from 16 to 15
                            height: 1.5, // Slightly reduced line height
                            letterSpacing: 0.2, // Reduced letter spacing
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Features Grid
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 75,
                              child: _buildFeatureCard(
                                Icons.headphones,
                                'Audio\nGuided',
                                'Perfect sync',
                              ),
                            ),
                            SizedBox(
                              width: 75,
                              child: _buildFeatureCard(
                                Icons.visibility,
                                'Visual\nPoses',
                                'Clear guidance',
                              ),
                            ),
                            SizedBox(
                              width: 75,
                              child: _buildFeatureCard(
                                Icons.tune,
                                'Custom\nFlows',
                                'Personal sessions',
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Browse Sessions Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
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
                              backgroundColor: const Color(0xFF7FB069),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: const Color(0xFF7FB069).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.explore, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Explore Sessions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Additional visual enhancements
                Container(
                  width: double.infinity,
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF7FB069).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // App Features Highlight
                Container(
                  padding: const EdgeInsets.all(20), // Reduced from 24 to 20
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7FB069).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: const Color(0xFF7FB069),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: const Text(
                              'What makes YogaVidya special?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      _buildHighlightRow(
                        Icons.psychology,
                        'Mindful Practice',
                        'Sync breath with movement',
                      ),
                      _buildHighlightRow(
                        Icons.trending_up,
                        'Progressive Learning',
                        'Build strength gradually',
                      ),
                      _buildHighlightRow(
                        Icons.spa,
                        'Holistic Wellness',
                        'Mind, body, and soul harmony',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // App Version and Credits
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'YogaVidya v1.0 • ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Made with ❤️ in Flutter',
                      style: TextStyle(
                        color: const Color(0xFF7FB069).withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF7FB069).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7FB069),
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 9,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7FB069).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7FB069),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
