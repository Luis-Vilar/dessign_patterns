# 🧱 Composite (Patrón estructural)

<!-- example: examples/estructurales/composite.dart -->

## La mudanza de Sofía

Sofía se muda y tiene que calcular cuánto pesa todo lo que va a llevar. Al
principio pesaba cada cosa por separado: un libro, una taza, una lámpara. Pero
también tiene cajas, y dentro de las cajas hay más cajas.

Si trata una caja y un libro de forma distinta, el cálculo se vuelve un
rompecabezas: tiene que abrir cada caja, sumar sus cosas y acordarse de volver
a cerrarla. En cambio, si puede preguntarle a **cualquier cosa** "¿cuánto
pesas?", el problema desaparece: un libro responde su peso, y una caja suma el
peso de todo lo que contiene, sin importar si adentro hay libros u otras cajas.

Eso es **Composite**: tratar un objeto individual y un grupo de objetos de la
misma manera, para poder recorrer una estructura en árbol sin casos especiales.

## La idea en una frase

Un árbol donde una hoja y una rama responden a la misma pregunta.

## ¿Cuándo usarlo?

- La información forma una estructura de árbol (carpetas, menús, organigramas).
- Quieres que el cliente trate igual una pieza suelta y un grupo de piezas.
- Las operaciones se repiten recursivamente sobre los hijos.

## ¿Cuándo NO usarlo?

- La estructura es plana: una lista normal es más simple.
- Las hojas y los contenedores tienen operaciones muy distintas y no comparten
  una interfaz real.
- Necesitas restricciones fuertes de tipos: `add()` solo existe en la carpeta,
  así que construir el árbol exige conocer el tipo concreto.

## Implementación en Dart

```dart
// Composite: trata un objeto individual y un grupo de objetos de la misma
// forma, para poder recorrer estructuras en árbol.

abstract class FileSystemEntry {
  String get name;
  int sizeInKb();

  // La misma operación para una hoja y para una carpeta.
  String describe([String prefix = '']);
}

class DocumentFile implements FileSystemEntry {
  @override
  final String name;

  final int size;

  DocumentFile(this.name, this.size);

  @override
  int sizeInKb() => size;

  @override
  String describe([String prefix = '']) => '$prefix$name (${sizeInKb()} KB)';
}

class Folder implements FileSystemEntry {
  @override
  final String name;

  final List<FileSystemEntry> _children = <FileSystemEntry>[];

  Folder(this.name);

  void add(FileSystemEntry entry) {
    _children.add(entry);
  }

  @override
  int sizeInKb() {
    var total = 0;
    for (final child in _children) {
      total += child.sizeInKb();
    }
    return total;
  }

  @override
  String describe([String prefix = '']) {
    final buffer = StringBuffer('$prefix$name/\n');
    for (final child in _children) {
      buffer.writeln(child.describe('$prefix  '));
    }
    return buffer.toString().trimRight();
  }
}

void run() {
  final root = Folder('proyecto');
  final source = Folder('src');
  source.add(DocumentFile('main.dart', 12));
  source.add(DocumentFile('utils.dart', 8));

  final assets = Folder('assets');
  assets.add(DocumentFile('logo.png', 250));

  root.add(source);
  root.add(assets);
  root.add(DocumentFile('README.md', 3));

  print(root.describe());
  print('Tamaño total: ${root.sizeInKb()} KB');
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/composite.dart
```

```text
proyecto/
  src/
    main.dart (12 KB)
    utils.dart (8 KB)
  assets/
    logo.png (250 KB)
  README.md (3 KB)
Tamaño total: 273 KB
```

`root.describe()` no pregunta si cada hijo es un archivo o una carpeta: llama
al mismo método `describe()` en todos. Esa uniformidad es todo el patrón.

## Se parece a...

- **Decorator:** también envuelve objetos, pero con **un** hijo y para agregar
  comportamiento. Composite contiene **muchos** hijos y representa un grupo.
- **Chain of Responsibility:** recorre una cadena lineal; Composite recorre un
  árbol.
- **Facade:** simplifica el acceso a un conjunto, pero no forma parte de la
  misma jerarquía que sus elementos.

## En Flutter

El árbol de widgets es un Composite: `Column`, `Row`, `Stack` y `Container`
pueden contener hijos, y Flutter recorre todos con las mismas operaciones de
layout y pintado, sin distinguir entre una hoja y un contenedor.

## Resumen

- Composite unifica hoja y contenedor bajo la misma interfaz.
- Las operaciones se resuelven de forma recursiva.
- Es ideal para árboles; es incómodo cuando las hojas y los grupos no
  comparten comportamiento.
