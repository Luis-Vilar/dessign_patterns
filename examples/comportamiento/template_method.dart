// Template Method: define el esqueleto de un algoritmo y deja que las
// subclases completen los pasos variables.

import 'dart:convert';

abstract class DataExporter {
  String export(List<Map<String, String>> rows) {
    final prepared = prepare(rows);
    final body = format(prepared);
    return '${header()}\n$body\n${footer()}';
  }

  String header();

  String footer();

  String format(List<Map<String, String>> rows);

  // Hook opcional: por defecto los datos pasan sin cambios.
  List<Map<String, String>> prepare(List<Map<String, String>> rows) => rows;
}

class CsvExporter extends DataExporter {
  @override
  String header() => '--- CSV ---';

  @override
  String footer() => '--- fin CSV ---';

  @override
  String format(List<Map<String, String>> rows) {
    final keys = rows.first.keys.toList();
    final lines = <String>[keys.join(',')];
    for (final row in rows) {
      lines.add(keys.map((key) => row[key] ?? '').join(','));
    }
    return lines.join('\n');
  }
}

class JsonExporter extends DataExporter {
  @override
  String header() => '--- JSON ---';

  @override
  String footer() => '--- fin JSON ---';

  @override
  String format(List<Map<String, String>> rows) {
    return const JsonEncoder.withIndent('  ').convert(rows);
  }
}

void run() {
  final rows = <Map<String, String>>[
    <String, String>{'name': 'Ana', 'city': 'Madrid'},
    <String, String>{'name': 'Luis', 'city': 'Bogotá'},
  ];

  print(CsvExporter().export(rows));
  print('');
  print(JsonExporter().export(rows));
}

void main() => run();
