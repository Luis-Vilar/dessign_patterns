# 🏭 Factory Method (Patrón creacional)

<!-- example: examples/creacionales/factory_method.dart -->

## La gestoría de Marina

Marina lleva una gestoría pequeña. Cada mes entrega a sus clientes un informe
de ventas. Al principio todo era un PDF que armaba a mano, y su programa tenía
un método `generarReporte(String tipo)` con un `if` para elegir el formato.

El negocio creció. Un cliente pidió el informe en CSV para abrirlo en su hoja
de cálculo. Otro lo quería en HTML para publicarlo en su web. Y apareció un
tercero que preguntó si podía ser en PDF, pero con otra portada.

Cada formato nuevo obligaba a Marina a abrir el mismo método, agregar otra
rama y volver a probar todos los formatos anteriores. Peor aún: el código que
enviaba el informe por correo también tenía que saber qué formato había
elegido.

Un día contrató a una practicante y le explicó el problema. La practicante
propuso algo simple: *"Que cada formato tenga su propio jefe de producción.
Todos siguen el mismo proceso —recibir los datos, darles forma y entregar el
resultado—, pero cada uno sabe cómo fabricar su versión. El área que envía el
informe solo le pide al jefe que genere el reporte, sin preguntar de qué tipo
es."*

Eso es exactamente el **Factory Method**: el flujo de trabajo vive en el
creador, y las subclases deciden qué producto concreto nace.

## La idea en una frase

El creador define **cuándo** y **cómo se usa** el producto; las subclases
deciden **cuál** se construye.

## ¿Cuándo usarlo?

- Tienes varios productos que comparten una interfaz y el código cliente no
  debería saber cuál se está usando.
- Esperas agregar más tipos en el futuro sin tocar el flujo existente.
- La creación viene acompañada de pasos comunes que conviene reutilizar.

## ¿Cuándo NO usarlo?

- Solo existe un producto y no hay planes reales de agregar otro: una clase
  normal es más clara.
- La elección se hace una sola vez al arrancar la app: inyectar la
  implementación directamente es más simple y más fácil de testear.
- Los productos no comparten comportamiento: inventar una interfaz común solo
  agrega ceremonia.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/creacionales/factory_method.dart
```

```text
[PDF] Reporte de ventas
  - Ana,120
  - Luis,80
  - Marta,45

vendedor,venta
Ana,120
Luis,80
Marta,45

<ul>
    <li>Ana,120</li>
    <li>Luis,80</li>
    <li>Marta,45</li>
</ul>
```

El cliente solo conoce `ReportCreator` y `Report`. Si mañana aparece un
formato XML, se agrega `XmlReport` y `XmlReportCreator`; el bucle de envío no
cambia.

## Se parece a...

- **Simple Factory:** una sola clase con un `if/else` sobre un texto. No es
  uno de los patrones GoF y obliga a modificar esa clase por cada tipo nuevo.
- **Abstract Factory:** crea **familias** de productos relacionados, no uno
  solo.
- **Builder:** construye un objeto complejo paso a paso; aquí lo importante es
  qué producto nace, no cómo se arma.

## En Flutter

`StatefulWidget.createState()` es un Factory Method real del framework: el
widget declara el método y cada subclase decide qué `State` concreto crear.
El framework se encarga del resto del ciclo de vida sin conocer esa clase.

## Resumen

- El creador define el flujo; las subclases deciden el producto.
- El cliente trabaja con interfaces, no con clases concretas.
- Agregar un tipo nuevo no obliga a tocar el código que ya funcionaba.
