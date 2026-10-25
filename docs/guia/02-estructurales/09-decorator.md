# 🧱 Decorator (Patrón estructural)

<!-- example: examples/estructurales/decorator.dart -->

## La tienda de regalos de Inés

Inés vende regalos. El cliente elige un producto y, si quiere, lo envuelve para
regalo, le pone un moño y agrega una tarjeta. Cada extra cambia el precio y la
presentación, y se pueden combinar en cualquier orden.

Al principio Inés tenía una clase por combinación: `RegaloConPapel`,
`RegaloConMoño`, `RegaloConPapelYMoño`, `RegaloConPapelMoñoYTarjeta`… Cada
extra nuevo duplicaba las clases existentes. Era el mismo problema de siempre:
las combinaciones crecen mucho más rápido que las opciones.

Entonces cambió el enfoque. Cada extra **envuelve** el regalo anterior y
conserva la misma interfaz: se puede preguntar el precio y la descripción a
cualquier regalo, envuelto o no. El papel envuelve el producto, el moño envuelve
el regalo con papel, la tarjeta envuelve el regalo con moño. Eso es
**Decorator**: agregar responsabilidades envolviendo, no heredando.

## La idea en una frase

Envuelve un objeto con otro que implementa la misma interfaz y le suma algo,
sin tocar el original.

## ¿Cuándo usarlo?

- Quieres agregar características de forma dinámica y combinable.
- La herencia produciría una explosión de subclases por cada combinación.
- No puedes o no quieres modificar la clase original.

## ¿Cuándo NO usarlo?

- Las combinaciones son pocas y fijas: la herencia o una configuración simple
  bastan.
- El orden de los decoradores es confuso o crítico y nadie lo documenta.
- Necesitas comparar tipos o identidades: al envolver, el objeto ya no es
  exactamente la clase que era.

## Implementación en Dart

```dart
// Decorator: agrega comportamiento a un objeto envolviéndolo con otro objeto
// que implementa la misma interfaz.

abstract class Gift {
  String describe();

  double price();
}

class BookGift implements Gift {
  final String title;

  const BookGift(this.title);

  @override
  String describe() => 'Libro "$title"';

  @override
  double price() => 20.0;
}

abstract class GiftDecorator implements Gift {
  final Gift gift;

  const GiftDecorator(this.gift);

  @override
  String describe() => gift.describe();

  @override
  double price() => gift.price();
}

class WrappingPaper extends GiftDecorator {
  const WrappingPaper(super.gift);

  @override
  String describe() => '${gift.describe()} con papel de regalo';

  @override
  double price() => gift.price() + 2.5;
}

class Ribbon extends GiftDecorator {
  const Ribbon(super.gift);

  @override
  String describe() => '${gift.describe()} con moño';

  @override
  double price() => gift.price() + 1.5;
}

class Card extends GiftDecorator {
  const Card(super.gift);

  @override
  String describe() => '${gift.describe()} con tarjeta';

  @override
  double price() => gift.price() + 3.0;
}

void run() {
  const base = BookGift('El jardín de las horas');
  print('${base.describe()} -> \$${base.price().toStringAsFixed(2)}');

  const wrapped = WrappingPaper(base);
  print('${wrapped.describe()} -> \$${wrapped.price().toStringAsFixed(2)}');

  const full = Card(Ribbon(wrapped));
  print('${full.describe()} -> \$${full.price().toStringAsFixed(2)}');
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/decorator.dart
```

```text
Libro "El jardín de las horas" -> $20.00
Libro "El jardín de las horas" con papel de regalo -> $22.50
Libro "El jardín de las horas" con papel de regalo con moño con tarjeta -> $27.00
```

El precio total no cambia si se envuelve en otro orden, pero la descripción sí:
no se lee igual "con papel con moño" que "con moño con papel". En
transformaciones reales, como comprimir y después cifrar, el orden también
cambia el resultado.

## Se parece a...

- **Composite:** también forma una estructura de envoltura, pero un Composite
  contiene **muchos** hijos y representa un grupo; un Decorator envuelve **uno**
  y le agrega comportamiento.
- **Proxy:** mantiene la misma interfaz, pero controla el acceso (permisos,
  caché, carga diferida); no se apila para sumar features.
- **Adapter:** cambia la interfaz. Decorator la conserva.

## En Flutter

Widgets como `Padding`, `Center`, `DecoratedBox` o `Opacity` envuelven un hijo
y le agregan una responsabilidad de layout o pintado, manteniendo la misma
naturaleza de widget. Es la misma idea: componer envolviendo.

## Resumen

- Decorator suma comportamiento sin modificar la clase original.
- Se combina en cadena y conserva la interfaz.
- El orden de la cadena es parte del diseño, no un detalle.
