# 🔄 Strategy (Patrón de comportamiento)

<!-- example: examples/comportamiento/strategy.dart -->

## La tienda de Ana

Ana tiene una tienda online. Sus clientes pueden pagar con tarjeta, con PayPal
o en efectivo al retirar. Cada medio tiene sus propias reglas: la tarjeta cobra
una comisión, PayPal otra, y el efectivo no cobra ninguna. Además, cada uno
devuelve un mensaje distinto.

Al principio Ana tenía un método `cobrar(String medio)` con un `if/else` que
mezclaba las tres formas de pago. Cada medio nuevo agregaba otra rama, y el
método crecía sin parar. Peor aún: el carrito tenía que saber qué texto mostrar
para cada caso.

Ana separó cada forma de pago en su propia clase, detrás de una interfaz común.
El carrito guarda una estrategia y le pide que cobre. Cuando el cliente cambia
de medio de pago, cambia la estrategia. El resto de la tienda no se entera. Eso
es **Strategy**: algoritmos intercambiables con la misma interfaz.

## La idea en una frase

Varios algoritmos, una misma entrada y salida; el cliente elige cuál usar.

## ¿Cuándo usarlo?

- Hay varias formas de hacer lo mismo y se eligen en tiempo de ejecución.
- Quieres evitar condicionales largos para seleccionar un algoritmo.
- Cada variante tiene reglas propias y merece su propia clase.

## ¿Cuándo NO usarlo?

- Solo existe una forma de hacerlo: una clase con un método es suficiente.
- Las variantes comparten casi todo y solo cambian un detalle: una función
  parámetro puede ser más simple.
- El cliente necesita conocer detalles internos de cada estrategia para
  configurarla.

## Implementación en Dart

```dart
// Strategy: encapsula algoritmos intercambiables detrás de una interfaz común.

abstract class PaymentStrategy {
  String pay(double amount);
}

class CardPayment implements PaymentStrategy {
  final String last4;

  const CardPayment(this.last4);

  @override
  String pay(double amount) {
    return 'Tarjeta ****$last4: cobrados \$${amount.toStringAsFixed(2)} '
        '(comisión 2%)';
  }
}

class PaypalPayment implements PaymentStrategy {
  final String email;

  const PaypalPayment(this.email);

  @override
  String pay(double amount) {
    return 'PayPal $email: cobrados \$${amount.toStringAsFixed(2)} '
        '(comisión 3%)';
  }
}

class CashPayment implements PaymentStrategy {
  const CashPayment();

  @override
  String pay(double amount) {
    return 'Efectivo: cobrados \$${amount.toStringAsFixed(2)} (sin comisión)';
  }
}

class Checkout {
  PaymentStrategy _strategy;

  Checkout(this._strategy);

  set strategy(PaymentStrategy value) {
    _strategy = value;
  }

  String pay(double amount) => _strategy.pay(amount);
}

void run() {
  final checkout = Checkout(const CardPayment('4242'));
  print(checkout.pay(100));

  checkout.strategy = const PaypalPayment('ana@example.com');
  print(checkout.pay(100));

  checkout.strategy = const CashPayment();
  print(checkout.pay(100));
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/comportamiento/strategy.dart
```

```text
Tarjeta ****4242: cobrados $100.00 (comisión 2%)
PayPal ana@example.com: cobrados $100.00 (comisión 3%)
Efectivo: cobrados $100.00 (sin comisión)
```

El `Checkout` no sabe cómo se procesa cada pago. Solo sabe que puede pedirle el
cobro a la estrategia actual. Agregar "transferencia bancaria" es crear una
clase nueva, no tocar el carrito.

## Se parece a...

- **State:** la estructura es parecida, pero en State el propio estado decide
  cuándo cambiar. En Strategy, el cliente elige la estrategia desde fuera.
- **Bridge:** separa dos jerarquías para que varíen por su cuenta. Strategy
  intercambia un algoritmo dentro de un objeto.
- **Command:** encapsula una petición completa; Strategy encapsula una forma de
  calcular.

## En Flutter

`ScrollPhysics` es una estrategia: `BouncingScrollPhysics`,
`ClampingScrollPhysics` y `NeverScrollableScrollPhysics` comparten la interfaz
y cambian cómo se comporta el desplazamiento. `PageTransitionsBuilder` hace lo
mismo con las animaciones entre pantallas.

## Resumen

- Strategy encapsula algoritmos intercambiables.
- El cliente elige cuál usar sin conocer los detalles.
- Evita condicionales largos y facilita agregar variantes.
