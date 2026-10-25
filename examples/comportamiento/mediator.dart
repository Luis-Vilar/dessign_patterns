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
