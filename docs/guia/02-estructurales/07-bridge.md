# 🧱 Bridge (Patrón estructural)

<!-- example: examples/estructurales/bridge.dart -->

## La editorial de Nora

Nora dirige una editorial pequeña. Publica libros y revistas, y tiene dos
prensas: una digital para tiradas cortas y una offset para tiradas grandes.

Al principio su programa tenía una clase por combinación: `LibroDigital`,
`LibroOffset`, `RevistaDigital`, `RevistaOffset`. Cuando agregó el formato
"catálogo", tuvo que crear dos clases más. Cuando compró una prensa nueva,
tuvo que tocar todas las publicaciones. El problema era que estaba mezclando
dos cosas que cambian por separado:

- **Qué se publica:** libro, revista, catálogo.
- **Cómo se imprime:** digital u offset.

Nora separó las dos dimensiones. Ahora una publicación **tiene** una prensa, en
lugar de heredar de ella. Un libro puede imprimirse en digital o en offset sin
crear una clase nueva por combinación. Eso es el **Bridge**: un puente entre
una abstracción y su implementación.

## La idea en una frase

Separa las dos dimensiones que varían para que crezcan por su cuenta, en lugar
de multiplicarse en subclases.

## ¿Cuándo usarlo?

- Tienes dos ejes de variación independientes (tipo de publicación × tipo de
  prensa, tipo de control × tipo de dispositivo).
- Quieres cambiar la implementación en tiempo de ejecución sin cambiar la
  abstracción.
- La herencia te obliga a crear una clase por cada combinación.

## ¿Cuándo NO usarlo?

- Solo hay un eje de variación: la herencia o una interfaz simple alcanzan.
- La implementación nunca cambia: el puente solo agrega indirección.
- Las dos dimensiones no son realmente independientes: forzar el patrón
  produce clases que se necesitan entre sí.

## Implementación en Dart

```dart
// Bridge: separa una abstracción (la publicación) de su implementación (la
// prensa) para que ambas puedan variar sin multiplicar clases.

abstract class PrintingPress {
  String get name;

  String print(String content);
}

class DigitalPress implements PrintingPress {
  @override
  String get name => 'digital';

  @override
  String print(String content) => 'Impresión digital de "$content"';
}

class OffsetPress implements PrintingPress {
  @override
  String get name => 'offset';

  @override
  String print(String content) => 'Impresión offset de "$content"';
}

abstract class Publication {
  final PrintingPress press;

  Publication(this.press);

  String produce();
}

class Book extends Publication {
  final String title;

  Book(super.press, this.title);

  @override
  String produce() {
    return 'Libro "$title" -> ${press.print('texto de $title')}';
  }
}

class Magazine extends Publication {
  final String name;

  Magazine(super.press, this.name);

  @override
  String produce() {
    return 'Revista "$name" -> ${press.print('artículos de $name')}';
  }
}

void run() {
  final book = Book(DigitalPress(), 'El jardín de las horas');
  final magazine = Magazine(OffsetPress(), 'Mundo Curioso');

  print(book.produce());
  print(magazine.produce());
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/bridge.dart
```

```text
Libro "El jardín de las horas" -> Impresión digital de "texto de El jardín de las horas"
Revista "Mundo Curioso" -> Impresión offset de "artículos de Mundo Curioso"
```

Si mañana aparece un catálogo, solo se crea `Catalog extends Publication`. Si
aparece una prensa láser, solo se implementa `PrintingPress`. Ninguna de las
dos ramas obliga a tocar la otra.

## Se parece a...

- **Adapter:** hace que dos interfaces incompatibles se entiendan **después**
  de que ya existían. Bridge se diseña **antes**, para separar dos jerarquías.
- **Strategy:** intercambia un algoritmo dentro de un objeto. Bridge separa
  una abstracción completa de su implementación y permite que ambas tengan
  variantes.
- **State:** el objeto cambia de comportamiento según su estado interno. Bridge
  elige una implementación desde fuera.

## En Flutter

En el código de una app Flutter no es un patrón que aparezca con nombre
propio. La separación entre el árbol de widgets y el árbol de `RenderObject`
sigue una idea parecida —describir y ejecutar por separado—, pero es
arquitectura interna del framework, no algo que uses al escribir una pantalla.

## Resumen

- Bridge conecta una abstracción con una implementación intercambiable.
- Evita el producto cartesiano de subclases.
- Las dos jerarquías crecen por separado.
