# 🔄 Observer (Patrón de comportamiento)

<!-- example: examples/comportamiento/observer.dart -->

## El boletín del barrio

En un barrio hay una junta de vecinos que publica novedades: un corte de agua,
una feria, una reunión. Al principio, cada vecino tenía que llamar a la
presidenta para preguntar si había algo nuevo. La presidenta pasaba el día
repitiendo la misma información.

Un día armaron una lista de correo. Quien quiere enterarse se suscribe; quien
se muda se da de baja. Cuando hay una novedad, la junta escribe **una vez** y
todos los suscritos reciben el aviso. La junta no necesita conocer a cada
vecino por su nombre ni saber qué hace con la información.

Eso es **Observer**: un sujeto mantiene una lista de interesados y les avisa
cuando cambia, sin acoplarse a sus clases concretas.

## La idea en una frase

El que cambia avisa; los interesados se suscriben y reaccionan a su manera.

## ¿Cuándo usarlo?

- Un objeto cambia y varios necesitan enterarse.
- No sabes de antemano cuántos interesados habrá.
- Quieres que el emisor y los receptores estén desacoplados.

## ¿Cuándo NO usarlo?

- Hay un solo receptor: una llamada directa es más clara.
- El orden de las notificaciones es crítico y no está definido.
- Los suscriptores nunca se dan de baja: se acumulan y generan fugas de
  memoria.

## Implementación en Dart

```dart
// Observer: cuando el sujeto cambia, avisa a todos los observadores
// suscritos sin conocer sus clases concretas.

abstract class Observer {
  void update(String news);
}

abstract class Subject {
  final List<Observer> _observers = <Observer>[];

  void subscribe(Observer observer) => _observers.add(observer);

  void unsubscribe(Observer observer) => _observers.remove(observer);

  void notify(String news) {
    for (final observer in List<Observer>.of(_observers)) {
      observer.update(news);
    }
  }
}

class Newsletter extends Subject {
  void publish(String news) {
    print('Boletín: $news');
    notify(news);
  }
}

class Subscriber implements Observer {
  final String name;

  Subscriber(this.name);

  @override
  void update(String news) => print('$name recibió: $news');
}

void run() {
  final newsletter = Newsletter();
  final ana = Subscriber('Ana');
  final luis = Subscriber('Luis');

  newsletter.subscribe(ana);
  newsletter.subscribe(luis);
  newsletter.publish('Nuevo curso disponible');

  newsletter.unsubscribe(luis);
  newsletter.publish('Segunda edición abierta');
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/observer.dart
```

```text
Boletín: Nuevo curso disponible
Ana recibió: Nuevo curso disponible
Luis recibió: Nuevo curso disponible
Boletín: Segunda edición abierta
Ana recibió: Segunda edición abierta
```

Luis se dio de baja y dejó de recibir el segundo aviso. El boletín no cambió:
siguió notificando a quien estaba en la lista.

## Se parece a...

- **Mediator:** centraliza la comunicación entre colegas que se hablan en
  ambas direcciones. Observer es un aviso de una dirección: del sujeto a los
  interesados.
- **Pub/Sub:** un intermediario (broker) desacopla por completo. Observer suele
  tener una referencia directa a sus observadores.
- **Strategy:** cambia un algoritmo; Observer cambia quién se entera de un
  cambio.

## En Flutter

`ChangeNotifier`, `ValueNotifier` y `Listenable` son Observer en el corazón del
framework: guardan una lista de listeners y los avisan cuando el valor cambia.
Los widgets que escuchan se reconstruyen sin que el notificador sepa cuáles
son.

## Resumen

- El sujeto mantiene suscriptores y los notifica.
- Emisor y receptores quedan desacoplados.
- Suscribirse es fácil; darse de baja también debe serlo.
