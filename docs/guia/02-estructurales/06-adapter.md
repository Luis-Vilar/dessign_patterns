# 🧱 Adapter (Patrón estructural)

<!-- example: examples/estructurales/adapter.dart -->

## El cargador de Tomás

Tomás viajó a Estados Unidos con su laptop. Al llegar al hotel quiso cargarla
y descubrió que el enchufe de la pared no tenía nada que ver con el de su
casa. La laptop funcionaba perfectamente; el problema era la conexión entre
dos formatos distintos.

No compró otra laptop ni rompió el enchufe del hotel. Compró un **adaptador**:
un objeto pequeño que recibe su clavija y entrega la forma que la pared
espera. Por dentro traduce; por fuera, para Tomás, todo sigue funcionando
igual.

En software, un **Adapter** hace eso mismo: envuelve una clase con una interfaz
incompatible y la presenta como si cumpliera la interfaz que el resto del
sistema ya usa.

## La idea en una frase

Convierte la interfaz de una clase en otra que el cliente espera, sin tocar
ninguna de las dos.

## ¿Cuándo usarlo?

- Necesitas usar una librería o un sistema legado cuya interfaz no encaja con
  la tuya.
- No puedes modificar ninguna de las dos partes (es código de terceros o ya
  está en producción).
- Quieres aislar el resto del sistema de una API externa que puede cambiar.

## ¿Cuándo NO usarlo?

- Tú controlas ambas interfaces: es más limpio cambiar una que agregar una capa.
- Solo necesitas simplificar el acceso a un conjunto de clases: eso es una
  **Facade**, no un Adapter.
- La diferencia no es de interfaz sino de comportamiento: quizá el problema
  sea de diseño y el adaptador solo lo tape.

## Implementación en Dart

```dart
// Adapter: permite que una clase con una interfaz incompatible trabaje con
// el resto del sistema sin modificarla.

abstract class PaymentProcessor {
  String pay(double amount);
}

// API antigua: trabaja con centavos y tiene otro nombre de método.
class LegacyBankApi {
  String makePayment(int cents, String currency) {
    return 'Banco antiguo: cobrados $cents centavos de $currency';
  }
}

// El adaptador traduce la interfaz nueva a la llamada antigua.
class LegacyBankAdapter implements PaymentProcessor {
  final LegacyBankApi _api;

  LegacyBankAdapter(this._api);

  @override
  String pay(double amount) {
    final cents = (amount * 100).round();
    return _api.makePayment(cents, 'USD');
  }
}

// El cliente solo conoce PaymentProcessor.
class Checkout {
  final PaymentProcessor processor;

  Checkout(this.processor);

  void finish(double total) {
    print(processor.pay(total));
  }
}

void run() {
  final checkout = Checkout(LegacyBankAdapter(LegacyBankApi()));
  checkout.finish(49.99);
  checkout.finish(10);
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/adapter.dart
```

```text
Banco antiguo: cobrados 4999 centavos de USD
Banco antiguo: cobrados 1000 centavos de USD
```

`Checkout` nunca supo que detrás había un banco antiguo. Solo vio un
`PaymentProcessor` con un método `pay`.

## Se parece a...

- **Facade:** simplifica el uso de **varias** clases detrás de una sola puerta.
  Adapter convierte **una** interfaz en otra.
- **Decorator:** envuelve un objeto, pero conserva la misma interfaz y le
  agrega comportamiento. Adapter **cambia** la interfaz.
- **Proxy:** también envuelve, pero mantiene la misma interfaz y controla el
  acceso.

## En Flutter

Cada vez que envuelves un paquete de terceros para que cumpla una interfaz
propia de tu app, estás usando un Adapter. También aparece al integrar APIs de
plataforma cuya forma no coincide con la que tu dominio necesita.

## Resumen

- Adapter traduce una interfaz a otra sin modificar el original.
- Es útil para integrar código legado o de terceros.
- No es lo mismo que Facade, Decorator ni Proxy, aunque todos envuelvan.
