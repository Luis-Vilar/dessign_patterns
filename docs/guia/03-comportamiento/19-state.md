# 🔄 State (Patrón de comportamiento)

<!-- example: examples/comportamiento/state.dart -->

## La máquina de café de la oficina

En la oficina hay una máquina de café con tres botones: moneda, preparar y
rellenar. No siempre hacen lo mismo. Si la máquina está esperando una moneda,
"preparar" no hace nada. Si ya tiene moneda y agua, "preparar" sirve el café.
Si se quedó sin agua, ninguna moneda entra y hay que rellenar el depósito.

Al principio el programa tenía un `if/else` por cada botón, y cada condición
repetía el estado actual: `if (estado == 'esperando' && monedas == 0)`, `if
(estado == 'lista' && agua > 0)`, y así. Cada estado nuevo obligaba a revisar
los tres botones.

La solución fue convertir cada estado en un objeto que sabe qué hacer con cada
botón. La máquina solo delega en el estado actual. Si está esperando moneda,
responde el estado "esperando"; si está lista, responde el estado "lista". Al
cambiar de estado, cambia todo el comportamiento junto. Eso es **State**.

## La idea en una frase

El objeto delega su comportamiento en un estado que puede intercambiarse, en
lugar de llenarse de condiciones.

## ¿Cuándo usarlo?

- El comportamiento cambia según un estado interno y hay muchas transiciones.
- Las condiciones sobre el estado se repiten por todo el código.
- Quieres que cada estado tenga sus propias reglas y sea fácil de leer.

## ¿Cuándo NO usarlo?

- Hay dos o tres estados simples y estables: unas banderas bien nombradas
  bastan.
- El estado es solo un dato que se muestra, no cambia el comportamiento.
- Las transiciones son tantas que el diagrama se vuelve inmanejable: quizá el
  problema pida una máquina de estados formal.

## Implementación en Dart

```dart
// State: el objeto cambia de comportamiento cuando cambia su estado interno.

abstract class CoffeeState {
  String get name;

  void insertCoin(CoffeeMachine machine);

  void pressBrew(CoffeeMachine machine);

  void refill(CoffeeMachine machine);
}

class CoffeeMachine {
  CoffeeState _state = const IdleState();

  int coins = 0;
  int water = 1;

  String get stateName => _state.name;

  void changeState(CoffeeState value) {
    _state = value;
    print('Estado: ${value.name}');
  }

  void insertCoin() => _state.insertCoin(this);

  void pressBrew() => _state.pressBrew(this);

  void refill() => _state.refill(this);
}

class IdleState implements CoffeeState {
  const IdleState();

  @override
  String get name => 'esperando moneda';

  @override
  void insertCoin(CoffeeMachine machine) {
    machine.coins++;
    print('Moneda aceptada');
    machine.changeState(const ReadyState());
  }

  @override
  void pressBrew(CoffeeMachine machine) {
    print('Primero inserta una moneda');
  }

  @override
  void refill(CoffeeMachine machine) {
    print('El depósito todavía tiene agua');
  }
}

class ReadyState implements CoffeeState {
  const ReadyState();

  @override
  String get name => 'lista para preparar';

  @override
  void insertCoin(CoffeeMachine machine) {
    machine.coins++;
    print('Moneda aceptada');
  }

  @override
  void pressBrew(CoffeeMachine machine) {
    machine.coins--;
    machine.water--;
    print('Café listo');

    if (machine.water == 0) {
      machine.changeState(const OutOfWaterState());
    } else {
      machine.changeState(const IdleState());
    }
  }

  @override
  void refill(CoffeeMachine machine) {
    print('Todavía queda agua');
  }
}

class OutOfWaterState implements CoffeeState {
  const OutOfWaterState();

  @override
  String get name => 'sin agua';

  @override
  void insertCoin(CoffeeMachine machine) {
    print('No se aceptan monedas: no hay agua');
  }

  @override
  void pressBrew(CoffeeMachine machine) {
    print('No hay agua: llama al técnico');
  }

  @override
  void refill(CoffeeMachine machine) {
    machine.water = 2;
    print('Depósito lleno');
    machine.changeState(const IdleState());
  }
}

void run() {
  final machine = CoffeeMachine();

  print('Inicio: ${machine.stateName}');
  machine.pressBrew();
  machine.insertCoin();
  machine.pressBrew();
  machine.pressBrew();
  machine.insertCoin();
  machine.refill();
  machine.insertCoin();
  machine.pressBrew();
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/state.dart
```

```text
Inicio: esperando moneda
Primero inserta una moneda
Moneda aceptada
Estado: lista para preparar
Café listo
Estado: sin agua
No hay agua: llama al técnico
No se aceptan monedas: no hay agua
Depósito lleno
Estado: esperando moneda
Moneda aceptada
Estado: lista para preparar
Café listo
Estado: esperando moneda
```

Cada estado decidió qué hacer con cada botón. La máquina no tiene un solo `if`
sobre el estado; solo delega.

## Se parece a...

- **Strategy:** ambos encapsulan comportamiento en objetos. En Strategy, el
  cliente elige el algoritmo desde fuera; en State, el propio estado decide la
  transición al siguiente.
- **Bridge:** separa dos jerarquías; State cambia el comportamiento de un
  objeto a lo largo del tiempo.
- **Command:** encapsula una acción; State encapsula una situación.

## En Flutter

Flutter no modela sus animaciones con estos objetos de estado, pero
`AnimationController` sí expone estados y transiciones —detenido, avanzando,
retrocediendo, completado— que cambian su comportamiento. Tómalo como una
intuición cercana, no como una implementación literal del patrón.

## Resumen

- State convierte cada situación en un objeto con su propio comportamiento.
- Elimina cadenas de condiciones sobre el estado.
- Las transiciones viven en los estados, no en el cliente.
