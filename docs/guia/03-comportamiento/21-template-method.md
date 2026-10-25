# 🔄 Template Method (Patrón de comportamiento)

<!-- example: examples/comportamiento/template_method.dart -->

## La imprenta de la facultad

La imprenta de una facultad recibe listas de estudiantes y las exporta en dos
formatos: CSV para las planillas y JSON para el sistema web. El proceso siempre
es el mismo:

1. Recibir los datos.
2. Darles el formato correspondiente.
3. Poner un encabezado.
4. Poner un pie.
5. Entregar el resultado.

Lo que cambia entre un formato y otro es el encabezado, el pie y la forma de
los datos; el orden de los pasos, en cambio, es siempre el mismo. Si alguien
escribe el proceso completo dos veces, cualquier cambio en ese orden hay que
hacerlo en dos lugares y tarde o temprano se olvida uno.

La imprenta decidió escribir **un solo** proceso con los pasos fijos y dejar
como huecos las partes que cambian. Eso es **Template Method**: una receta con
el esqueleto del algoritmo y ganchos para lo que varía.

## La idea en una frase

El algoritmo vive en la clase base; las subclases solo completan los pasos que
cambian.

## ¿Cuándo usarlo?

- Varios procesos comparten la misma secuencia de pasos.
- Quieres garantizar el orden y evitar que cada subclase lo reescriba.
- Solo uno o dos pasos varían entre las variantes.

## ¿Cuándo NO usarlo?

- El algoritmo completo cambia entre variantes: conviene Strategy, que
  intercambia todo el cálculo.
- Los pasos son independientes y se combinan libremente: la herencia se vuelve
  rígida.
- Necesitas composición en lugar de herencia para poder probar cada pieza por
  separado.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/template_method.dart
```

```text
--- CSV ---
name,city
Ana,Madrid
Luis,Bogotá
--- fin CSV ---

--- JSON ---
[
  {
    "name": "Ana",
    "city": "Madrid"
  },
  {
    "name": "Luis",
    "city": "Bogotá"
  }
]
--- fin JSON ---
```

Las dos subclases comparten el orden y el método `prepare()`, pero cada una
define su propio `header()`, `footer()` y `format()`. La clase base se encarga
de llamarlos en la misma secuencia. `prepare()` es un gancho: si un exportador
necesita limpiar datos, puede sobrescribirlo; si no, hereda el comportamiento
vacío.

## Se parece a...

- **Strategy:** intercambia el algoritmo completo mediante composición.
  Template Method fija el esqueleto y varía pasos mediante herencia.
- **Factory Method:** suele ser un paso dentro de un Template Method: la clase
  base define el flujo y la subclase decide qué producto crear.
- **Builder:** también tiene pasos, pero su objetivo es construir un objeto, no
  ejecutar un algoritmo.

## En Flutter

El ciclo de vida de un `State` es un Template Method: el framework define el
orden (`initState`, `build`, `dispose`) y tú sobrescribes los ganchos que
necesitas. No llamas tú a `initState`; el framework lo hace en el momento
correcto.

## Resumen

- Template Method fija el orden del algoritmo en la clase base.
- Las subclases completan solo los pasos variables.
- Es herencia con un contrato claro; úsalo cuando el esqueleto sea estable.
