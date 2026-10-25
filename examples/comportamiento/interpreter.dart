// Interpreter: representa reglas como un árbol de expresiones que se pueden
// combinar y evaluar.

class Order {
  final double total;
  final String category;
  final bool frequentCustomer;

  const Order(this.total, this.category, {this.frequentCustomer = false});
}

abstract class Expression {
  bool evaluate(Order order);
}

class MinAmount implements Expression {
  final double amount;

  const MinAmount(this.amount);

  @override
  bool evaluate(Order order) => order.total >= amount;
}

class CategoryIs implements Expression {
  final String category;

  const CategoryIs(this.category);

  @override
  bool evaluate(Order order) => order.category == category;
}

class FrequentCustomer implements Expression {
  const FrequentCustomer();

  @override
  bool evaluate(Order order) => order.frequentCustomer;
}

class AndExpression implements Expression {
  final Expression left;
  final Expression right;

  const AndExpression(this.left, this.right);

  @override
  bool evaluate(Order order) => left.evaluate(order) && right.evaluate(order);
}

class OrExpression implements Expression {
  final Expression left;
  final Expression right;

  const OrExpression(this.left, this.right);

  @override
  bool evaluate(Order order) => left.evaluate(order) || right.evaluate(order);
}

class NotExpression implements Expression {
  final Expression expression;

  const NotExpression(this.expression);

  @override
  bool evaluate(Order order) => !expression.evaluate(order);
}

void run() {
  final rule = AndExpression(
    const MinAmount(50),
    OrExpression(
      NotExpression(const CategoryIs('electronicos')),
      const FrequentCustomer(),
    ),
  );

  final orders = <Order>[
    const Order(80, 'libros'),
    const Order(30, 'libros'),
    const Order(120, 'electronicos'),
    const Order(120, 'electronicos', frequentCustomer: true),
  ];

  for (final order in orders) {
    final result = rule.evaluate(order) ? 'aplica' : 'no aplica';
    print('${order.category} \$${order.total.toStringAsFixed(2)} -> $result');
  }
}

void main() => run();
