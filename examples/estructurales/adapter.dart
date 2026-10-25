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
