# 🔄 Command (Patrón de comportamiento)

<!-- example: examples/comportamiento/command.dart -->

## El robot del almacén

En un almacén, un robot se mueve entre estanterías. Cada movimiento es una
orden: "avanza tres pasos", "retrocede dos". El operador puede equivocarse y
necesita deshacer la última orden, o volver a aplicarla si se arrepiente.

Al principio el programa ejecutaba el movimiento directamente: cambiaba la
posición del robot y nada más. Cuando quisieron agregar "deshacer", no había
forma de saber qué había pasado antes. El botón no tenía memoria de la acción,
solo el efecto.

Entonces cada orden se convirtió en un **objeto** con dos métodos: `execute()`
y `undo()`. Avanzar es un objeto; retroceder es otro. El operador guarda las
órdenes en una pila y puede deshacer o rehacer. Eso es **Command**: convertir
una petición en un objeto que se puede guardar, ejecutar y revertir.

## La idea en una frase

Una acción convertida en objeto, con todo lo necesario para ejecutarse y
revertirse.

## ¿Cuándo usarlo?

- Necesitas deshacer y rehacer.
- Quieres encolar, programar o registrar operaciones.
- La acción debe poder ejecutarse sin que quien la pide conozca a quien la
  realiza.

## ¿Cuándo NO usarlo?

- Las acciones son simples y no necesitan historial: una llamada directa es más
  clara.
- No hay forma razonable de revertir la operación (por ejemplo, enviar un
  correo).
- Cada comando necesita media docena de clases auxiliares y el beneficio no
  aparece.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/command.dart
```

```text
Ejecutado: mover 3 pasos
Ejecutado: mover 2 pasos
Robot en posición 5
Deshecho: mover 2 pasos
Después de undo: posición 3
Rehecho: mover 2 pasos
Después de redo: posición 5
Deshecho: mover 2 pasos
Deshecho: mover 3 pasos
Todo deshecho: posición 0
```

La pila de deshacer es la memoria del robot. Si se ejecuta un comando nuevo
después de deshacer, la pila de rehacer se limpia: ya no hay un futuro que
rehacer.

## Se parece a...

- **Memento:** también permite deshacer, pero guardando una foto completa del
  estado. Command revierte con la operación inversa.
- **Strategy:** encapsula un algoritmo; Command encapsula una petición con su
  receptor y su forma de deshacerse.
- **Chain of Responsibility:** decide quién atiende; Command empaqueta qué se
  debe hacer.

## En Flutter

El sistema de `Intent` y `Action` de Flutter encapsula una intención del
usuario (copiar, pegar, deshacer) en un objeto que se puede invocar y
reutilizar desde atajos de teclado, menús o botones. Es la misma idea de fondo:
la acción deja de estar pegada al botón.

## Resumen

- Command convierte una acción en un objeto.
- Permite historial, deshacer, rehacer y encolado.
- Cada comando debe saber ejecutarse y, si aplica, revertirse.
