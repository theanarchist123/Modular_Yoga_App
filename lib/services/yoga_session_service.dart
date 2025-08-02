import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/yoga_session.dart';

class YogaSessionService {
  static Future<YogaSession> loadYogaSession(String jsonPath) async {
    try {
      final String response = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> data = json.decode(response);
      return YogaSession.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load yoga session: $e');
    }
  }

  static String getImagePath(String imageName) {
    return 'assets/images/$imageName';
  }

  static String getAudioPath(String audioName) {
    return 'audio/$audioName';
  }

  static List<YogaSequence> expandLoopableSequences(
    List<YogaSequence> sequences,
    int loopCount,
  ) {
    List<YogaSequence> expandedSequences = [];
    
    for (var sequence in sequences) {
      if (sequence.type == 'loop' && sequence.loopable == true) {
        // Add the loop sequence multiple times
        for (int i = 0; i < loopCount; i++) {
          expandedSequences.add(sequence);
        }
      } else {
        expandedSequences.add(sequence);
      }
    }
    
    return expandedSequences;
  }
}
