# 🔄 Memento (Patrón de comportamiento)

<!-- example: examples/comportamiento/memento.dart -->

## Las partidas guardadas de Lucía

Lucía está jugando una aventura. Antes de entrar a la cueva del jefe, guarda la
partida. Si pierde, vuelve al punto de guardado y lo intenta otra vez.

Por dentro, el juego tiene nivel, vida, inventario y un montón de datos más.
Lucía no necesita verlos: solo necesita que el juego sea capaz de tomar una
**foto** del estado y devolverlo después exactamente como estaba. Si el juego
le entregara su estado interno, cualquiera podría modificarlo por accidente.

Eso es **Memento**: guardar una instantánea del estado de un objeto para
restaurarla más tarde, sin exponer sus detalles internos.

## La idea en una frase

Una foto del estado que se guarda aparte y se puede restaurar tal cual.

## ¿Cuándo usarlo?

- Necesitas deshacer cambios restaurando un estado anterior.
- Quieres guardar puntos de control o transacciones.
- El estado interno es delicado y no debe exponerse.

## ¿Cuándo NO usarlo?

- El estado es enorme y guardar copias consume demasiada memoria.
- El estado se puede reconstruir fácilmente con los datos que ya tienes.
- No necesitas volver atrás: guardar fotos por si acaso es complejidad inútil.

## Implementación en Dart

```dart
// Memento: guarda una foto del estado para poder restaurarla después, sin
// exponer los detalles internos del objeto.

class GameState {
  final int level;
  final int health;

  const GameState(this.level, this.health);

  @override
  String toString() => 'nivel $level, vida $health';
}

class GameMemento {
  final GameState _state;

  const GameMemento(this._state);
}

class Game {
  GameState _state = const GameState(1, 100);

  GameState get state => _state;

  void play(int level, int health) {
    _state = GameState(level, health);
  }

  GameMemento save() => GameMemento(_state);

  void restore(GameMemento memento) {
    _state = memento._state;
  }
}

class Caretaker {
  final List<GameMemento> _saves = <GameMemento>[];

  void save(GameMemento memento) => _saves.add(memento);

  GameMemento? undo() => _saves.isEmpty ? null : _saves.removeLast();
}

void run() {
  final game = Game();
  final caretaker = Caretaker();

  print('Inicio: ${game.state}');
  caretaker.save(game.save());

  game.play(2, 80);
  print('Después de jugar: ${game.state}');
  caretaker.save(game.save());

  game.play(3, 10);
  print('Después del jefe: ${game.state}');

  final lastSave = caretaker.undo();
  if (lastSave != null) {
    game.restore(lastSave);
  }
  print('Restaurado: ${game.state}');
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/memento.dart
```

```text
Inicio: nivel 1, vida 100
Después de jugar: nivel 2, vida 80
Después del jefe: nivel 3, vida 10
Restaurado: nivel 2, vida 80
```

El `Caretaker` guarda las fotos, pero no puede leer su contenido a través de la
interfaz pública. El `Game` decide cuándo tomarlas y cuándo restaurarlas. Cada
uno tiene una responsabilidad clara.

## Se parece a...

- **Command:** también permite deshacer, pero revirtiendo la operación. Memento
  restaura una foto completa del estado.
- **Prototype:** copia objetos. Memento usa esa copia como un recuerdo, no como
  un objeto nuevo para trabajar.
- **State:** cambia el comportamiento según el estado actual. Memento guarda y
  restaura ese estado.

## En Flutter

`RestorationMixin` y `RestorableState` permiten que una pantalla guarde parte
de su estado y lo recupere si el sistema operativo destruye la app en segundo
plano. Es la misma idea: una foto que sobrevive al cierre.

## Resumen

- Memento captura el estado sin exponer los detalles internos.
- El cuidador guarda las fotos; el objeto original decide cuándo restaurarlas.
- Vigila el costo en memoria de cada instantánea.
