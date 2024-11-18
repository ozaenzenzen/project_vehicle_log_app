import 'dart:convert';

void main() {
  const jsonString = '''
  {
    "id": 1,
    "name": "John Doe",
    "email": "johndoe@example.com",
    "isActive": true,
    "createdAt": "2024-11-17T00:00:00Z",
    "tags": ["developer", "designer"]
  }
  ''';

  generateDartModel('UserModel', jsonString);
}

void generateDartModel(String className, String jsonString) {
  final Map<String, dynamic> jsonData = jsonDecode(jsonString);
  final buffer = StringBuffer();

  buffer.writeln('class $className {');

  jsonData.forEach((key, value) {
    final dartType = _getDartType(value);
    buffer.writeln('  final $dartType $key;');
  });

  buffer.writeln('\n  $className({');
  jsonData.forEach((key, value) {
    buffer.writeln('    required this.$key,');
  });
  buffer.writeln('  });\n');

  buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  jsonData.forEach((key, value) {
    buffer.writeln('      $key: json[\'$key\'] as ${_getDartType(value)},');
  });
  buffer.writeln('    );');
  buffer.writeln('  }\n');

  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  jsonData.forEach((key, value) {
    buffer.writeln('      \'$key\': $key,');
  });
  buffer.writeln('    };');
  buffer.writeln('  }');

  buffer.writeln('}');

  print(buffer.toString());
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