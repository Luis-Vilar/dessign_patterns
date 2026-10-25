import 'dart:io';

/// Ejecuta todos los archivos de `examples/` en procesos separados.
///
/// Se usa un proceso por ejemplo para que un fallo no detenga a los demás y
/// para no depender de imports estáticos que crecerían con cada patrón.
Future<void> main() async {
  final root = Directory.current.path;
  final examplesDir = Directory('$root/examples');

  if (!examplesDir.existsSync()) {
    stderr.writeln('No existe el directorio examples/.');
    exit(1);
  }

  final files = examplesDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  const expectedExamples = 23;
  if (files.length != expectedExamples) {
    stderr.writeln('✗ Se esperaban $expectedExamples ejemplos y se '
        'encontraron ${files.length}.');
    exit(1);
  }

  var failures = 0;

  for (final file in files) {
    final relative = file.path.replaceFirst('$root/', '');
    print('\n▶ $relative');

    final result = await Process.run(
      Platform.resolvedExecutable,
      <String>['run', file.path],
      workingDirectory: root,
    );

    stdout.write(result.stdout);
    if (result.stderr.toString().trim().isNotEmpty) {
      stderr.write(result.stderr);
    }

    if (result.exitCode != 0) {
      failures++;
      stderr.writeln('✗ Falló $relative (código ${result.exitCode})');
    }
  }

  final passed = files.length - failures;
  print('\n$passed/${files.length} ejemplos ejecutados correctamente.');

  if (failures > 0) {
    exit(1);
  }
}
