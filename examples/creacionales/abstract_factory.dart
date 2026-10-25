// Abstract Factory: una fábrica por familia. Los productos de una misma
// familia están diseñados para usarse juntos.

abstract class Tablecloth {
  String get description;
}

abstract class Plates {
  String get description;
}

abstract class Balloons {
  String get description;
}

class JungleTablecloth implements Tablecloth {
  @override
  String get description => 'Mantel verde con hojas';
}

class JunglePlates implements Plates {
  @override
  String get description => 'Platos con animales de la selva';
}

class JungleBalloons implements Balloons {
  @override
  String get description => 'Globos de colores selváticos';
}

class SpaceTablecloth implements Tablecloth {
  @override
  String get description => 'Mantel azul con estrellas';
}

class SpacePlates implements Plates {
  @override
  String get description => 'Platos con planetas';
}

class SpaceBalloons implements Balloons {
  @override
  String get description => 'Globos plateados';
}

abstract class PartyKitFactory {
  String get theme;

  Tablecloth createTablecloth();

  Plates createPlates();

  Balloons createBalloons();
}

class JungleKitFactory implements PartyKitFactory {
  @override
  String get theme => 'Selva';

  @override
  Tablecloth createTablecloth() => JungleTablecloth();

  @override
  Plates createPlates() => JunglePlates();

  @override
  Balloons createBalloons() => JungleBalloons();
}

class SpaceKitFactory implements PartyKitFactory {
  @override
  String get theme => 'Espacio';

  @override
  Tablecloth createTablecloth() => SpaceTablecloth();

  @override
  Plates createPlates() => SpacePlates();

  @override
  Balloons createBalloons() => SpaceBalloons();
}

void run() {
  final factories = <PartyKitFactory>[
    JungleKitFactory(),
    SpaceKitFactory(),
  ];

  for (final factory in factories) {
    print('--- Kit ${factory.theme} ---');
    print(factory.createTablecloth().description);
    print(factory.createPlates().description);
    print(factory.createBalloons().description);
    print('');
  }
}

void main() => run();
