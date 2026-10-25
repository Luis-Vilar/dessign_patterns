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
