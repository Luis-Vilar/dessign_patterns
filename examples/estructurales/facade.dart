// Facade: una puerta simple para un conjunto de subsistemas que trabajan
// juntos.

class Inventory {
  bool hasStock(String productId) {
    print('Inventario: stock de $productId verificado');
    return true;
  }
}

class PaymentService {
  bool charge(String customer, double amount) {
    print('Pago: $customer pagó \$${amount.toStringAsFixed(2)}');
    return true;
  }
}

class ShippingService {
  String schedule(String productId) {
    print('Envío: $productId programado');
    return 'ENV-123';
  }
}

class CheckoutFacade {
  final Inventory _inventory;
  final PaymentService _payment;
  final ShippingService _shipping;

  CheckoutFacade({
    Inventory? inventory,
    PaymentService? payment,
    ShippingService? shipping,
  })  : _inventory = inventory ?? Inventory(),
        _payment = payment ?? PaymentService(),
        _shipping = shipping ?? ShippingService();

  String buy({
    required String customer,
    required String productId,
    required double amount,
  }) {
    if (!_inventory.hasStock(productId)) {
      return 'Compra cancelada: sin stock';
    }
    if (!_payment.charge(customer, amount)) {
      return 'Compra cancelada: pago rechazado';
    }
    final tracking = _shipping.schedule(productId);
    return 'Compra completada. Seguimiento: $tracking';
  }
}

void run() {
  final checkout = CheckoutFacade();
  final result = checkout.buy(
    customer: 'Ana',
    productId: 'LIBRO-42',
    amount: 29.9,
  );
  print(result);
}

void main() => run();
