import 'package:flutter/cupertino.dart';

class ModelSuggestion {
  final String model;

  ModelSuggestion({@required this.model});

  Map<String, dynamic> toMap() {
    return {
      'model': model,
    };
  }
}

class PartsSuggestion {
  final String parts;

  PartsSuggestion({@required this.parts});

  Map<String, dynamic> toMap() {
    return {
      'parts': parts,
    };
  }
}

class NamaSuggestion {
  final String nama;

  NamaSuggestion({@required this.nama});

  Map<String, dynamic> toMap() {
    return {
      'name': nama,
    };
  }
}

class RosakSuggestion {
  final String rosak;

  RosakSuggestion({@required this.rosak});

  Map<String, dynamic> toMap() {
    return {
      'rosak': rosak,
    };
  }
}
