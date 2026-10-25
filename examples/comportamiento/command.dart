// Command: encapsula una acción como un objeto para poder ejecutarla,
// deshacerla y rehacerla.

abstract class Command {
  String get description;

  void execute();

  void undo();
}

class Robot {
  int position = 0;

  String get positionText => 'posición $position';
}

class MoveCommand implements Command {
  final Robot robot;
  final int distance;

  MoveCommand(this.robot, this.distance);

  @override
  String get description => 'mover $distance pasos';

  @override
  void execute() {
    robot.position += distance;
  }

  @override
  void undo() {
    robot.position -= distance;
  }
}

class CommandManager {
  final List<Command> _undoStack = <Command>[];
  final List<Command> _redoStack = <Command>[];

  void execute(Command command) {
    command.execute();
    _undoStack.add(command);
    _redoStack.clear();
    print('Ejecutado: ${command.description}');
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
    print('Deshecho: ${command.description}');
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
    print('Rehecho: ${command.description}');
  }
}

void run() {
  final robot = Robot();
  final manager = CommandManager();

  manager.execute(MoveCommand(robot, 3));
  manager.execute(MoveCommand(robot, 2));
  print('Robot en ${robot.positionText}');

  manager.undo();
  print('Después de undo: ${robot.positionText}');

  manager.redo();
  print('Después de redo: ${robot.positionText}');

  manager.undo();
  manager.undo();
  print('Todo deshecho: ${robot.positionText}');
}

void main() => run();
