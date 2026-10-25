# 🔄 Interpreter (Patrón de comportamiento)

<!-- example: examples/comportamiento/interpreter.dart -->

## Las reglas de descuento de la librería

La dueña de una librería quiere ofrecer descuentos, pero no quiere un menú
fijo de promociones. Quiere combinarlas:

- "Más de 50 dólares".
- "Que no sea de la categoría electrónicos".
- "Cliente frecuente".

Quiere combinarlas así: "más de 50 dólares **y**, además, que no sea
electrónico **o** que el cliente sea frecuente".

Cada regla suelta es fácil. El problema es combinarlas con "y", "o" y "no" sin
terminar con un método lleno de condiciones que hay que reescribir cada vez que
aparece una promoción nueva.

La solución es representar cada regla como una **expresión** que sabe
evaluarse, y componer expresiones con otras expresiones. La regla anterior es
un árbol: un `And` con un `MinAmount` y un `Or` que contiene un `Not` y un
`FrequentCustomer`. Eso es **Interpreter**: un pequeño lenguaje donde cada nodo
del árbol sabe evaluarse.

## La idea en una frase

Una regla se representa como un árbol de expresiones que se combinan y se
evalúan sobre un contexto.

## ¿Cuándo usarlo?

- Tienes un conjunto pequeño y estable de reglas que se combinan con
  operadores.
- Quieres que las reglas se lean como se describen en el negocio.
- La gramática es simple y no necesitas un parser completo.

## ¿Cuándo NO usarlo?

- La gramática es grande o cambia seguido: un parser real o un motor de reglas
  es mejor.
- Solo hay una o dos condiciones fijas: un `if` bien escrito gana.
- El rendimiento es crítico y el árbol agrega demasiada indirección.

## Implementación en Dart

```dart
// Interpreter: representa reglas como un árbol de expresiones que se pueden
// combinar y evaluar.

class Order {
  final double total;
  final String category;
  final bool frequentCustomer;

  const Order(this.total, this.category, {this.frequentCustomer = false});
}

abstract class Expression {
  bool evaluate(Order order);
}

class MinAmount implements Expression {
  final double amount;

  const MinAmount(this.amount);

  @override
  bool evaluate(Order order) => order.total >= amount;
}

class CategoryIs implements Expression {
  final String category;

  const CategoryIs(this.category);

  @override
  bool evaluate(Order order) => order.category == category;
}

class FrequentCustomer implements Expression {
  const FrequentCustomer();

  @override
  bool evaluate(Order order) => order.frequentCustomer;
}

class AndExpression implements Expression {
  final Expression left;
  final Expression right;

  const AndExpression(this.left, this.right);

  @override
  bool evaluate(Order order) => left.evaluate(order) && right.evaluate(order);
}

class OrExpression implements Expression {
  final Expression left;
  final Expression right;

  const OrExpression(this.left, this.right);

  @override
  bool evaluate(Order order) => left.evaluate(order) || right.evaluate(order);
}

class NotExpression implements Expression {
  final Expression expression;

  const NotExpression(this.expression);

  @override
  bool evaluate(Order order) => !expression.evaluate(order);
}

void run() {
  final rule = AndExpression(
    const MinAmount(50),
    OrExpression(
      NotExpression(const CategoryIs('electronicos')),
      const FrequentCustomer(),
    ),
  );

  final orders = <Order>[
    const Order(80, 'libros'),
    const Order(30, 'libros'),
    const Order(120, 'electronicos'),
    const Order(120, 'electronicos', frequentCustomer: true),
  ];

  for (final order in orders) {
    final result = rule.evaluate(order) ? 'aplica' : 'no aplica';
    print('${order.category} \$${order.total.toStringAsFixed(2)} -> $result');
  }
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/interpreter.dart
```

```text
libros $80.00 -> aplica
libros $30.00 -> no aplica
electronicos $120.00 -> no aplica
electronicos $120.00 -> aplica
```

La regla se lee de arriba abajo: `And(MinAmount(50), Or(Not(CategoryIs(...)),
FrequentCustomer()))`. La última línea muestra el efecto del `Or`: un pedido de
electrónicos por 120 dólares entra solo porque el cliente es frecuente.

## Se parece a...

- **Composite:** también forma un árbol, pero su objetivo es representar una
  estructura de partes. Interpreter evalúa una gramática.
- **Strategy:** encapsula un algoritmo; Interpreter compone expresiones que
  representan una regla.
- **Visitor:** puede recorrerse un árbol de expresiones para evaluarlo o
  imprimirlo, pero Visitor es la operación, no la gramática.

## En Flutter

No es un patrón habitual en el código de una app Flutter. Aparece cuando hay
reglas de negocio combinables —descuentos, validaciones, filtros— y conviene
modelarlas como expresiones en lugar de condiciones dispersas. Para gramáticas
grandes, un motor de reglas o un parser suele ser mejor.

## Resumen

- Interpreter modela reglas como un árbol de expresiones evaluables.
- Las reglas se combinan con operadores como `And`, `Or` y `Not`.
- Funciona con gramáticas pequeñas; no reemplaza a un parser.
