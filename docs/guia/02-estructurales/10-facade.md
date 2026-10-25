# 🧱 Facade (Patrón estructural)

<!-- example: examples/estructurales/facade.dart -->

## La recepción del hotel

Un huésped llega al hotel y quiere tres cosas: que lo lleven al aeropuerto,
una mesa para cenar y que lo despierten a las siete. No llama por teléfono al
departamento de transporte, al restaurante y al servicio de habitaciones por
separado. Habla con **recepción**, y recepción coordina a los tres.

La recepción no reemplaza a los departamentos ni hace su trabajo: los conoce y
los ordena. Para el huésped, hay una sola puerta y una sola conversación. Para
el hotel, cada departamento sigue existiendo y puede cambiar por dentro.

Eso es una **Facade**: una interfaz simple que esconde la coordinación de un
conjunto de subsistemas.

## La idea en una frase

Una puerta de entrada simple para un sistema que por dentro tiene varias
piezas y un orden que respetar.

## ¿Cuándo usarlo?

- Una operación común requiere coordinar varios subsistemas en un orden
  concreto.
- Quieres reducir el acoplamiento entre el cliente y esas piezas internas.
- El 90 % de los usos sigue el mismo flujo y no necesita control fino.

## ¿Cuándo NO usarlo?

- El cliente necesita controlar cada paso por separado: la fachada se vuelve
  un cuello de botella.
- La fachada empieza a acumular toda la lógica del sistema: se convierte en
  una clase gigante que todos tocan.
- El subsistema ya es simple: agregar una fachada solo suma una capa.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/facade.dart
```

```text
Inventario: stock de LIBRO-42 verificado
Pago: Ana pagó $29.90
Envío: LIBRO-42 programado
Compra completada. Seguimiento: ENV-123
```

El cliente hizo una sola llamada. El orden —stock, pago, envío— quedó dentro
de la fachada, donde se puede cambiar sin tocar a quien compra.

## Se parece a...

- **Adapter:** convierte **una** interfaz en otra. Facade **coordina varias**
  y ofrece una puerta nueva.
- **Mediator:** coordina objetos que se comunican entre sí en ambas
  direcciones. Facade es de una sola dirección: el cliente pide, la fachada
  organiza.
- **Proxy:** tiene la misma interfaz que el objeto real y controla el acceso.
  Facade simplifica, no sustituye.

## En Flutter

`Navigator` es una fachada sobre la pila de rutas, las transiciones y las
superposiciones. Quien navega llama a `push` o `pop`; no necesita coordinar a
mano todo lo que ocurre detrás para cambiar de pantalla.

## Resumen

- Facade ofrece una operación simple para un flujo que involucra varios
  subsistemas.
- Reduce el acoplamiento y centraliza el orden de los pasos.
- No debe convertirse en el lugar donde vive toda la lógica.
