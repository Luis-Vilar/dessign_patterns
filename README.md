# Patrones de diseño en Dart/Flutter

Una guía en español para entender los 23 patrones de diseño del catálogo GoF
sin dolor. Cada patrón tiene una historia cotidiana, una explicación corta, un
ejemplo ejecutable en Dart y una sección sobre cuándo **no** usarlo.

## Cómo leerla

1. Empieza por [Cómo leer esta guía](docs/guia/00-como-leer.md).
2. Lee la historia del patrón y quédate con la idea en una frase.
3. Abre el ejemplo y ejecútalo.
4. Vuelve al documento para ver cuándo aplica y con qué patrón se confunde.

## Cómo ejecutar los ejemplos

Requiere Dart 3.5 o superior.

```bash
dart run examples/creacionales/factory_method.dart
```

Para ejecutar los 23 de una vez y comprobar que el código de los documentos
coincide con los archivos:

```bash
dart run tool/run_examples.dart
dart run tool/check_docs.dart
dart analyze
```

## Índice

### Creacionales

| # | Patrón | Documento | Ejemplo |
|---|---|---|---|
| 1 | Factory Method | [Leer](docs/guia/01-creacionales/01-factory-method.md) | [Código](examples/creacionales/factory_method.dart) |
| 2 | Abstract Factory | [Leer](docs/guia/01-creacionales/02-abstract-factory.md) | [Código](examples/creacionales/abstract_factory.dart) |
| 3 | Builder | [Leer](docs/guia/01-creacionales/03-builder.md) | [Código](examples/creacionales/builder.dart) |
| 4 | Prototype | [Leer](docs/guia/01-creacionales/04-prototype.md) | [Código](examples/creacionales/prototype.dart) |
| 5 | Singleton | [Leer](docs/guia/01-creacionales/05-singleton.md) | [Código](examples/creacionales/singleton.dart) |

### Estructurales

| # | Patrón | Documento | Ejemplo |
|---|---|---|---|
| 6 | Adapter | [Leer](docs/guia/02-estructurales/06-adapter.md) | [Código](examples/estructurales/adapter.dart) |
| 7 | Bridge | [Leer](docs/guia/02-estructurales/07-bridge.md) | [Código](examples/estructurales/bridge.dart) |
| 8 | Composite | [Leer](docs/guia/02-estructurales/08-composite.md) | [Código](examples/estructurales/composite.dart) |
| 9 | Decorator | [Leer](docs/guia/02-estructurales/09-decorator.md) | [Código](examples/estructurales/decorator.dart) |
| 10 | Facade | [Leer](docs/guia/02-estructurales/10-facade.md) | [Código](examples/estructurales/facade.dart) |
| 11 | Flyweight | [Leer](docs/guia/02-estructurales/11-flyweight.md) | [Código](examples/estructurales/flyweight.dart) |
| 12 | Proxy | [Leer](docs/guia/02-estructurales/12-proxy.md) | [Código](examples/estructurales/proxy.dart) |

### De comportamiento

| # | Patrón | Documento | Ejemplo |
|---|---|---|---|
| 13 | Chain of Responsibility | [Leer](docs/guia/03-comportamiento/13-chain-of-responsibility.md) | [Código](examples/comportamiento/chain_of_responsibility.dart) |
| 14 | Command | [Leer](docs/guia/03-comportamiento/14-command.md) | [Código](examples/comportamiento/command.dart) |
| 15 | Iterator | [Leer](docs/guia/03-comportamiento/15-iterator.md) | [Código](examples/comportamiento/iterator.dart) |
| 16 | Mediator | [Leer](docs/guia/03-comportamiento/16-mediator.md) | [Código](examples/comportamiento/mediator.dart) |
| 17 | Memento | [Leer](docs/guia/03-comportamiento/17-memento.md) | [Código](examples/comportamiento/memento.dart) |
| 18 | Observer | [Leer](docs/guia/03-comportamiento/18-observer.md) | [Código](examples/comportamiento/observer.dart) |
| 19 | State | [Leer](docs/guia/03-comportamiento/19-state.md) | [Código](examples/comportamiento/state.dart) |
| 20 | Strategy | [Leer](docs/guia/03-comportamiento/20-strategy.md) | [Código](examples/comportamiento/strategy.dart) |
| 21 | Template Method | [Leer](docs/guia/03-comportamiento/21-template-method.md) | [Código](examples/comportamiento/template_method.dart) |
| 22 | Visitor | [Leer](docs/guia/03-comportamiento/22-visitor.md) | [Código](examples/comportamiento/visitor.dart) |
| 23 | Interpreter | [Leer](docs/guia/03-comportamiento/23-interpreter.md) | [Código](examples/comportamiento/interpreter.dart) |

## Licencia y atribución

El código está bajo licencia MIT y el texto bajo CC BY 4.0. Los nombres y la
estructura de los patrones vienen del catálogo GoF; los relatos, explicaciones
y ejemplos son originales. No se incluyen imágenes de terceros.
