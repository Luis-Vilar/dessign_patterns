# 🔄 Chain of Responsibility (Patrón de comportamiento)

<!-- example: examples/comportamiento/chain_of_responsibility.dart -->

## El reembolso de Marta

Marta trabaja en una empresa y necesita que le aprueben un gasto. No sabe a
quién dirigirse: depende del monto. Si son hasta cien dólares, lo aprueba su
supervisor. Si son hasta mil, hace falta el gerente. Si es más, decide el
director.

Antes, Marta tenía que averiguar el monto y elegir a la persona correcta. Si se
equivocaba, el pedido volvía y empezaba de nuevo. Cada cambio en los límites
obligaba a actualizar su lista mental.

Ahora hay un único canal: Marta envía el gasto a su supervisor. Si él puede
aprobarlo, lo hace; si no, lo pasa al gerente; el gerente hace lo mismo con el
director. Marta no necesita saber dónde termina la cadena. Eso es **Chain of
Responsibility**: una fila de manejadores donde cada uno decide si atiende o
delega en el siguiente.

## La idea en una frase

Cada eslabón intenta resolver la petición y, si no puede, la pasa al siguiente.

## ¿Cuándo usarlo?

- Varios objetos pueden manejar una petición y el adecuado se decide en tiempo
  de ejecución.
- El orden de los manejadores importa y quieres poder cambiarlo.
- Quien envía la petición no debería conocer a todos los posibles receptores.

## ¿Cuándo NO usarlo?

- Solo hay un manejador posible: una llamada directa es más clara.
- La petición **debe** ser atendida siempre y no hay un caso por defecto: la
  cadena puede terminar en silencio.
- La cadena es larga y difícil de seguir: depurar se vuelve una pesadilla.

## Implementación en Dart

```dart
// Chain of Responsibility: cada manejador intenta resolver la petición y, si
// no puede, la pasa al siguiente.

class Expense {
  final String concept;
  final double amount;

  const Expense(this.concept, this.amount);
}

abstract class Approver {
  Approver? _next;

  Approver setNext(Approver next) {
    _next = next;
    return next;
  }

  String approve(Expense expense) {
    if (canApprove(expense)) {
      return '$name aprobó "${expense.concept}" '
          'por \$${expense.amount.toStringAsFixed(2)}';
    }

    final next = _next;
    if (next == null) {
      return 'Nadie pudo aprobar "${expense.concept}" '
          'por \$${expense.amount.toStringAsFixed(2)}';
    }

    return next.approve(expense);
  }

  String get name;

  bool canApprove(Expense expense);
}

class Supervisor extends Approver {
  @override
  String get name => 'Supervisor';

  @override
  bool canApprove(Expense expense) => expense.amount <= 100;
}

class Manager extends Approver {
  @override
  String get name => 'Gerente';

  @override
  bool canApprove(Expense expense) => expense.amount <= 1000;
}

class Director extends Approver {
  @override
  String get name => 'Director';

  @override
  bool canApprove(Expense expense) => true;
}

void run() {
  final supervisor = Supervisor();
  final manager = Manager();
  final director = Director();

  supervisor.setNext(manager).setNext(director);

  final expenses = <Expense>[
    const Expense('Material de oficina', 80),
    const Expense('Capacitación', 500),
    const Expense('Equipo nuevo', 5000),
  ];

  for (final expense in expenses) {
    print(supervisor.approve(expense));
  }
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/chain_of_responsibility.dart
```

```text
Supervisor aprobó "Material de oficina" por $80.00
Gerente aprobó "Capacitación" por $500.00
Director aprobó "Equipo nuevo" por $5000.00
```

Marta siempre llama a `supervisor.approve(...)`. El supervisor no sabe si el
gerente o el director existen; solo conoce al siguiente.

## Se parece a...

- **Decorator:** también encadena objetos y pasa la llamada, pero **siempre**
  la pasa y agrega comportamiento. Chain puede detenerse cuando alguien
  resuelve.
- **Composite:** recorre un árbol de objetos; Chain recorre una línea.
- **Command:** encapsula la petición como objeto; Chain decide quién la atiende.

## En Flutter

Las notificaciones de Flutter suben por el árbol de widgets hasta que alguien
las maneja. `NotificationListener` captura la que le interesa y puede dejar que
otras sigan subiendo: es una cadena de responsabilidad sobre el árbol.

## Resumen

- Cada eslabón intenta resolver y, si no puede, delega.
- El emisor solo conoce el primer eslabón.
- Define siempre un final claro para las peticiones que nadie atiende.
