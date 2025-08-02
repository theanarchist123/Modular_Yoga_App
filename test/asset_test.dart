import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  group('Asset Tests', () {
    test('JSON file should be accessible', () async {
      try {
        final String response = await rootBundle.loadString('CatCowJson.json');
        final Map<String, dynamic> data = json.decode(response);
        
        expect(data['metadata'], isNotNull);
        expect(data['assets'], isNotNull);
        expect(data['sequence'], isNotNull);
        
        print('JSON loaded successfully');
        print('Title: ${data['metadata']['title']}');
        print('Audio files: ${data['assets']['audio']}');
        print('Image files: ${data['assets']['images']}');
      } catch (e) {
        fail('Failed to load JSON: $e');
      }
    });
  });
}
