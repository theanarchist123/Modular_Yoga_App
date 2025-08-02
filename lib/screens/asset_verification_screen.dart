import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetVerificationScreen extends StatefulWidget {
  const AssetVerificationScreen({super.key});

  @override
  State<AssetVerificationScreen> createState() => _AssetVerificationScreenState();
}

class _AssetVerificationScreenState extends State<AssetVerificationScreen> {
  List<String> _verificationResults = [];
  
  final List<String> _assetsToCheck = [
    'assets/CatCowJson.json',
    'assets/images/Base.png',
    'assets/images/Cat.png',
    'assets/images/Cow.png',
    'assets/audio/cat_cow_intro.mp3',
    'assets/audio/cat_cow_loop.mp3',
    'assets/audio/cat_cow_outro.mp3',
  ];

  @override
  void initState() {
    super.initState();
    _verifyAssets();
  }

  Future<void> _verifyAssets() async {
    List<String> results = [];
    
    for (String assetPath in _assetsToCheck) {
      try {
        await rootBundle.load(assetPath);
        results.add('✅ Found: $assetPath');
      } catch (e) {
        results.add('❌ Missing: $assetPath - $e');
      }
    }
    
    setState(() {
      _verificationResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Asset Verification',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _verifyAssets,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Re-verify Assets'),
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: _verificationResults.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _verificationResults[index],
                        style: TextStyle(
                          color: _verificationResults[index].startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
