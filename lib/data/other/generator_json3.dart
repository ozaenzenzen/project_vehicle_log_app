import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
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

  // Get the directory of the script
  final scriptDir = File(Platform.script.toFilePath()).parent;

  // Start generating the main class and any nested classes
  final models = generateClassFromJson(className, jsonData);

  // Save each class to its own Dart file
  models.forEach((className, classCode) {
    final fileName = '${className.toLowerCase()}.dart';
    final filePath = '${scriptDir.path}/$fileName';
    final file = File(filePath);
    file.writeAsStringSync(classCode);

    debugPrint('Dart model saved to $filePath');
  });
}

Map<String, String> generateClassFromJson(String className, Map<String, dynamic> jsonData) {
  final models = <String, String>{};
  final buffer = StringBuffer();

  buffer.writeln('class $className {');

  // Generate fields
  jsonData.forEach((key, value) {
    final dartType = _getDartType(key, value, models);
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
    buffer.writeln('      $key: ${_getFromJson(key, value)},');
  });
  buffer.writeln('    );');
  buffer.writeln('  }\n');

  // Add toJson method
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  jsonData.forEach((key, value) {
    buffer.writeln('      \'$key\': ${_getToJson(key, value)},');
  });
  buffer.writeln('    };');
  buffer.writeln('  }');

  buffer.writeln('}');

  models[className] = buffer.toString();
  return models;
}

String _getDartType(String key, dynamic value, Map<String, String> models) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) return 'String';
  if (value is List) {
    if (value.isNotEmpty && value.first is Map) {
      final nestedClassName = '${_capitalize(key)}Item';
      final nestedModels = generateClassFromJson(nestedClassName, value.first as Map<String, dynamic>);
      models.addAll(nestedModels);
      return 'List<$nestedClassName>';
    }
    return 'List<${_getDartType(key, value.isEmpty ? null : value.first, models)}>';
  }
  if (value is Map) {
    final nestedClassName = _capitalize(key);
    final nestedModels = generateClassFromJson(nestedClassName, value as Map<String, dynamic>);
    models.addAll(nestedModels);
    return nestedClassName;
  }
  return 'dynamic';
}

String _getFromJson(String key, dynamic value) {
  if (value is List && value.isNotEmpty && value.first is Map) {
    final itemType = '${_capitalize(key)}Item';
    return '(json[\'$key\'] as List).map((e) => $itemType.fromJson(e as Map<String, dynamic>)).toList()';
  }
  if (value is Map) {
    final typeName = _capitalize(key);
    return '$typeName.fromJson(json[\'$key\'] as Map<String, dynamic>)';
  }
  return 'json[\'$key\']';
}

String _getToJson(String key, dynamic value) {
  if (value is List && value.isNotEmpty && value.first is Map) {
    return '$key.map((e) => e.toJson()).toList()';
  }
  if (value is Map) {
    return '$key.toJson()';
  }
  return key;
}

String _capitalize(String input) {
  return input[0].toUpperCase() + input.substring(1);
}