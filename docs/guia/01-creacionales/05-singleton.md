# 🏭 Singleton (Patrón creacional)

<!-- example: examples/creacionales/singleton.dart -->

## La impresora del tercer piso

En una oficina hay una sola impresora para todo el piso. Al principio cada
área instaló "su" controlador y armó "su" cola de impresión. El resultado fue
predecible: dos personas enviaban trabajos a la vez, la impresora recibía
órdenes contradictorias y las hojas salían mezcladas.

La solución fue sencilla: una única cola compartida y una sola extensión
telefónica para enviar trabajos. No importa quién llame ni desde qué programa;
todos hablan con la misma cola. Hay una sola, y eso es justamente lo que evita
el caos.

El patrón **Singleton** hace lo mismo en el código: garantiza que una clase
tenga **una única instancia** y ofrece un punto de acceso común a ella.

## La idea en una frase

Una sola instancia, compartida por todo el programa, creada la primera vez que
se necesita.

## ¿Cuándo usarlo?

- Existe un recurso que realmente debe ser único: configuración global, un
  logger, una cola de impresión, un caché compartido.
- Crear la instancia es caro y conviene reutilizarla.
- Muchas partes del programa necesitan el mismo estado coordinado.

## ¿Cuándo NO usarlo?

- Solo quieres evitar pasar un objeto por parámetros: eso es comodidad, no una
  necesidad de unicidad.
- El estado va a cambiar y varias partes lo van a modificar: se vuelve un
  global disfrazado y las pruebas empiezan a depender del orden en que corren.
- Necesitas más de una instancia en pruebas o en distintos entornos.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/creacionales/singleton.dart
```

```text
Entorno: production | Tema oscuro: true
¿Misma instancia? true
```

La línea `¿Misma instancia? true` es la que importa: `first` y `second` no son
dos objetos iguales, son **el mismo objeto**.

## Dos matices que suelen omitirse

- **Singleton no sincroniza nada.** Garantiza una instancia, no una fila de
  espera. Si dos operaciones asíncronas modifican el mismo estado, pueden
  pisarse igual. La concurrencia se resuelve aparte.
- **En Dart, cada isolate tiene su propia memoria.** Un Singleton es único
  dentro de un isolate, no necesariamente dentro de toda la aplicación.

## Se parece a...

- **Clase con métodos estáticos:** también da acceso global, pero no es un
  objeto y no puede implementar una interfaz ni recibir dependencias.
- **Inyección de dependencias:** permite una sola instancia cuando hace falta,
  pero sin esconder la dependencia; es la opción preferida en aplicaciones
  grandes.
- **Flyweight:** comparte objetos para ahorrar memoria, pero puede haber muchos
  y se identifican por una clave. Singleton es uno solo.

## En Flutter

`WidgetsBinding.instance` es un Singleton real del framework: hay un único
punto de enlace con el sistema operativo. Para el estado de la aplicación, en
cambio, casi siempre conviene inyectar dependencias o usar el mecanismo de
gestión de estado que ya tenga el proyecto, en lugar de esconder un global.

## Resumen

- Una instancia, un punto de acceso, creación perezosa.
- No resuelve concurrencia ni sustituye una buena arquitectura.
- Úsalo para recursos genuinamente únicos, no para evitar pasar parámetros.
