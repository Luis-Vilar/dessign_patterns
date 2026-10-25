import 'dart:io';

/// Comprueba que el bloque Dart de cada documento coincide con su ejemplo.
///
/// El documento declara la ruta con `<!-- example: examples/... -->` y debe
/// contener un único bloque cercado con ```dart. El archivo de `examples/` es
/// la fuente de verdad: si el bloque y el archivo difieren, este programa falla.
void main() {
  final root = Directory.current.path;
  final docsDir = Directory('$root/docs/guia');

  if (!docsDir.existsSync()) {
    stderr.writeln('No existe el directorio docs/guia/.');
    exit(1);
  }

  final docs = docsDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.md'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var checked = 0;
  var failures = 0;
  const expectedDocs = 23;

  for (final doc in docs) {
    final relativeDoc = doc.path.replaceFirst('$root/', '');
    final text = doc.readAsStringSync();
    final marker = RegExp(r'<!--\s*example:\s*(\S+?)\s*-->').firstMatch(text);

    if (marker == null) {
      print('· $relativeDoc (sin ejemplo, se omite)');
      continue;
    }

    final relativeExample = marker.group(1)!;
    final example = File('$root/$relativeExample');

    if (!example.existsSync()) {
      failures++;
      stderr.writeln('✗ $relativeDoc apunta a un archivo inexistente: '
          '$relativeExample');
      continue;
    }

    final blocks = _dartBlocks(text);
    if (blocks.length != 1) {
      failures++;
      stderr.writeln('✗ $relativeDoc debe tener exactamente un bloque ```dart '
          '(tiene ${blocks.length}).');
      continue;
    }

    final expected = _normalize(example.readAsStringSync());
    final actual = _normalize(blocks.single);

    if (actual != expected) {
      failures++;
      stderr.writeln('✗ $relativeDoc no coincide con $relativeExample');
      _printFirstDifference(expected, actual);
      continue;
    }

    checked++;
  }

  if (checked != expectedDocs) {
    failures++;
    stderr.writeln('✗ Se esperaban $expectedDocs documentos sincronizados y '
        'se verificaron $checked.');
  }

  print('\n$checked documentos sincronizados con su ejemplo.');
  if (failures > 0) {
    exit(1);
  }
}

List<String> _dartBlocks(String text) {
  final blocks = <String>[];
  final pattern = RegExp(r'```dart\r?\n([\s\S]*?)```');
  for (final match in pattern.allMatches(text)) {
    blocks.add(match.group(1)!);
  }
  return blocks;
}

String _normalize(String source) {
  final lines = source.replaceAll('\r\n', '\n').split('\n');
  final trimmed = lines.map((line) => line.trimRight()).toList();
  while (trimmed.isNotEmpty && trimmed.first.isEmpty) {
    trimmed.removeAt(0);
  }
  while (trimmed.isNotEmpty && trimmed.last.isEmpty) {
    trimmed.removeLast();
  }
  return trimmed.join('\n');
}

void _printFirstDifference(String expected, String actual) {
  final expectedLines = expected.split('\n');
  final actualLines = actual.split('\n');
  final limit = expectedLines.length < actualLines.length
      ? expectedLines.length
      : actualLines.length;

  for (var i = 0; i < limit; i++) {
    if (expectedLines[i] != actualLines[i]) {
      stderr.writeln('  primera diferencia en la línea ${i + 1}:');
      stderr.writeln('  ejemplo:   ${expectedLines[i]}');
      stderr.writeln('  documento: ${actualLines[i]}');
      return;
    }
  }

  stderr.writeln('  el documento tiene ${actualLines.length} líneas y el '
      'ejemplo ${expectedLines.length}.');
}
