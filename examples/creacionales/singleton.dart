// Singleton: una sola instancia compartida y un punto de acceso global.

class AppConfig {
  // La instancia se crea la primera vez que se usa.
  static final AppConfig _instance = AppConfig._internal();

  // El constructor factory siempre devuelve la misma instancia.
  factory AppConfig() => _instance;

  // Constructor privado: evita crear objetos con `AppConfig._internal()`.
  AppConfig._internal();

  String environment = 'development';
  bool darkMode = false;

  void describe() {
    print('Entorno: $environment | Tema oscuro: $darkMode');
  }
}

void run() {
  final first = AppConfig();
  final second = AppConfig();

  first.environment = 'production';
  first.darkMode = true;

  // La segunda referencia ve exactamente el mismo estado.
  second.describe();
  print('¿Misma instancia? ${identical(first, second)}');
}

void main() => run();
