import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  // const jsonString = '''
  // {
  //   "id": 1,
  //   "name": "John Doe",
  //   "email": "johndoe@example.com",
  //   "isActive": true,
  //   "createdAt": "2024-11-17T00:00:00Z",
  //   "tags": ["developer", "designer"]
  // }
  // ''';
  const jsonString = '''
  {
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}
  ''';

  const className = 'UserModel';
  generateDartModelFile(className, jsonString);
}

void generateDartModelFile(String className, String jsonString) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  final buffer = StringBuffer();

  buffer.writeln('class $className {');

  // Add fields
  jsonData.forEach((key, value) {
    final dartType = _getDartType(value);
    buffer.writeln('  final $dartType $key;');
  });

  // Add constructor
  buffer.writeln('\n  $className({');
  jsonData.forEach((key, _) {
    buffer.writeln('    required this.$key,');
  });
  buffer.writeln('  });\n');

  // Add factory constructor
  buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  jsonData.forEach((key, value) {
    buffer.writeln('      $key: json[\'$key\'] as ${_getDartType(value)},');
  });
  buffer.writeln('    );');
  buffer.writeln('  }\n');

  // Add toJson method
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  jsonData.forEach((key, _) {
    buffer.writeln('      \'$key\': $key,');
  });
  buffer.writeln('    };');
  buffer.writeln('  }');

  buffer.writeln('}');

  // Get the directory of the script
  final scriptDir = File(Platform.script.toFilePath()).parent;

  // Save to a Dart file in the same directory as the script
  final fileName = '${className.toLowerCase()}.dart';
  final filePath = '${scriptDir.path}/$fileName';
  final file = File(filePath);
  file.writeAsStringSync(buffer.toString());

  debugPrint('Dart model saved to $filePath');
}

String _getDartType(dynamic value) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) return 'String';
  if (value is List) return 'List<String>'; // Customize for complex lists
  if (value is Map) return 'Map<String, dynamic>';
  return 'dynamic';
}