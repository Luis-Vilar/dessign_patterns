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
