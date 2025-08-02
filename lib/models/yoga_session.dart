class YogaSession {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;
  final Map<String, String> images;
  final Map<String, String> audio;
  final List<YogaSequence> sequence;

  YogaSession({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
    required this.images,
    required this.audio,
    required this.sequence,
  });

  factory YogaSession.fromJson(Map<String, dynamic> json) {
    return YogaSession(
      id: json['metadata']['id'],
      title: json['metadata']['title'],
      category: json['metadata']['category'],
      defaultLoopCount: json['metadata']['defaultLoopCount'],
      tempo: json['metadata']['tempo'],
      images: Map<String, String>.from(json['assets']['images']),
      audio: Map<String, String>.from(json['assets']['audio']),
      sequence: (json['sequence'] as List)
          .map((seq) => YogaSequence.fromJson(seq))
          .toList(),
    );
  }
}

class YogaSequence {
  final String type;
  final String name;
  final String audioRef;
  final int durationSec;
  final int? iterations;
  final bool? loopable;
  final List<YogaScript> script;

  YogaSequence({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    this.iterations,
    this.loopable,
    required this.script,
  });

  factory YogaSequence.fromJson(Map<String, dynamic> json) {
    final scripts = (json['script'] as List)
        .map((script) => YogaScript.fromJson(script))
        .toList();
    
    // Calculate duration from the last script's end time
    final calculatedDuration = scripts.isNotEmpty ? scripts.last.endSec : 0;

    return YogaSequence(
      type: json['type'],
      name: json['name'],
      audioRef: json['audioRef'],
      durationSec: calculatedDuration, // Use calculated duration
      iterations: json['iterations'] is String ? null : json['iterations'],
      loopable: json['loopable'],
      script: scripts,
    );
  }
}

class YogaScript {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;
  final String? audioRef; // Can be null if no specific audio for this script

  YogaScript({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
    this.audioRef,
  });

  factory YogaScript.fromJson(Map<String, dynamic> json) {
    return YogaScript(
      text: json['text'],
      startSec: json['startSec'],
      endSec: json['endSec'],
      imageRef: json['imageRef'],
      audioRef: json['audioRef'], // Will be null if not in JSON
    );
  }
}
