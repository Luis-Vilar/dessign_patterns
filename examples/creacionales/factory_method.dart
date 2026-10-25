// Factory Method: el creador define el flujo y las subclases deciden
// qué reporte concreto se construye.

abstract class Report {
  String get format;

  String render(List<String> rows);
}

class PdfReport implements Report {
  @override
  String get format => 'PDF';

  @override
  String render(List<String> rows) {
    final body = rows.map((row) => '  - $row').join('\n');
    return '[$format] Reporte de ventas\n$body';
  }
}

class CsvReport implements Report {
  @override
  String get format => 'CSV';

  @override
  String render(List<String> rows) => 'vendedor,venta\n${rows.join('\n')}';
}

class HtmlReport implements Report {
  @override
  String get format => 'HTML';

  @override
  String render(List<String> rows) {
    final items = rows.map((row) => '    <li>$row</li>').join('\n');
    return '<ul>\n$items\n</ul>';
  }
}

abstract class ReportCreator {
  // El método factoría: cada subclase decide el producto.
  Report createReport();

  // El flujo común no sabe qué reporte concreto está usando.
  String generate(List<String> rows) {
    final report = createReport();
    return report.render(rows);
  }
}

class PdfReportCreator extends ReportCreator {
  @override
  Report createReport() => PdfReport();
}

class CsvReportCreator extends ReportCreator {
  @override
  Report createReport() => CsvReport();
}

class HtmlReportCreator extends ReportCreator {
  @override
  Report createReport() => HtmlReport();
}

void run() {
  final rows = <String>['Ana,120', 'Luis,80', 'Marta,45'];
  final creators = <ReportCreator>[
    PdfReportCreator(),
    CsvReportCreator(),
    HtmlReportCreator(),
  ];

  for (final creator in creators) {
    print(creator.generate(rows));
    print('');
  }
}

void main() => run();
