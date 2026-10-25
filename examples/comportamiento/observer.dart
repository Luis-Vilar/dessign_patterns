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
