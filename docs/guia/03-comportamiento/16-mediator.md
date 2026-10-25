# 🔄 Mediator (Patrón de comportamiento)

<!-- example: examples/comportamiento/mediator.dart -->

## La torre de control

En un aeropuerto, los aviones no se avisan entre sí quién aterriza primero. Si
cada piloto tuviera que llamar a todos los demás, la comunicación sería un
caos: nadie sabría a quién creerle ni en qué orden llegar.

En cambio, todos hablan con **una** torre de control. La torre recibe la
petición, decide el turno y avisa. Los aviones no necesitan conocerse entre
ellos; solo necesitan conocer la torre. Si mañana hay un avión nuevo, la torre
lo coordina sin que los demás cambien.

Eso es **Mediator**: un objeto central que coordina la comunicación entre
varios colegas, para que ellos no tengan que conocerse entre sí.

## La idea en una frase

En lugar de que todos hablen con todos, todos hablan con el mediador.

## ¿Cuándo usarlo?

- Muchos objetos se comunican de formas complejas y las relaciones crecen en
  todas las direcciones.
- Quieres centralizar reglas de coordinación en un solo lugar.
- Los objetos deberían poder reutilizarse sin arrastrar a todos los demás.

## ¿Cuándo NO usarlo?

- Solo hay dos objetos que se hablan: una referencia directa es más simple.
- El mediador empieza a saber demasiado y se convierte en un dios que todos
  consultan.
- La comunicación es en una sola dirección y sin coordinación: una Facade
  alcanza.

## Implementación en Dart

```dart
// Mediator: centraliza la comunicación entre objetos que de otro modo
// tendrían que conocerse entre sí.

abstract class Mediator {
  void requestLanding(Aircraft aircraft);
}

class Aircraft {
  final String name;
  final Mediator mediator;

  Aircraft(this.name, this.mediator);

  void requestLanding() => mediator.requestLanding(this);

  void land() => print('$name aterrizó');
}

class ControlTower implements Mediator {
  final Set<String> _assigned = <String>{};

  @override
  void requestLanding(Aircraft aircraft) {
    if (_assigned.contains(aircraft.name)) {
      print('Torre: ${aircraft.name} ya tiene pista asignada');
      return;
    }

    _assigned.add(aircraft.name);
    print('Torre: pista asignada a ${aircraft.name}');
    aircraft.land();
  }
}

void run() {
  final tower = ControlTower();
  final flight101 = Aircraft('Vuelo 101', tower);
  final flight202 = Aircraft('Vuelo 202', tower);

  flight101.requestLanding();
  flight202.requestLanding();
  flight101.requestLanding();
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/mediator.dart
```

```text
Torre: pista asignada a Vuelo 101
Vuelo 101 aterrizó
Torre: pista asignada a Vuelo 202
Vuelo 202 aterrizó
Torre: Vuelo 101 ya tiene pista asignada
```

Ningún avión llamó a otro. La torre es el único punto donde vive la regla de
"una pista por vez".

## Se parece a...

- **Facade:** simplifica el acceso a un subsistema, pero no coordina objetos
  que se hablan en ambas direcciones. Mediator sí.
- **Observer:** el sujeto avisa a muchos sin esperar respuesta. Mediator
  coordina y decide.
- **Chain of Responsibility:** la petición viaja por una cadena hasta que
  alguien la atiende. Mediator centraliza la decisión en un punto.

## En Flutter

Un `Form` coordina a sus `FormField`: valida, guarda y reinicia a todos sus
hijos. Los campos no se conocen entre sí; hablan con el formulario, que es el
mediador del grupo.

## Resumen

- Mediator centraliza la comunicación y reduce las dependencias cruzadas.
- Los colegas solo conocen al mediador.
- El riesgo es que el mediador acumule demasiada lógica.
