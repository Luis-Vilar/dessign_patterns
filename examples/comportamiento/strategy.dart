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
