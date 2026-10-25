// Chain of Responsibility: cada manejador intenta resolver la petición y, si
// no puede, la pasa al siguiente.

class Expense {
  final String concept;
  final double amount;

  const Expense(this.concept, this.amount);
}

abstract class Approver {
  Approver? _next;

  Approver setNext(Approver next) {
    _next = next;
    return next;
  }

  String approve(Expense expense) {
    if (canApprove(expense)) {
      return '$name aprobó "${expense.concept}" '
          'por \$${expense.amount.toStringAsFixed(2)}';
    }

    final next = _next;
    if (next == null) {
      return 'Nadie pudo aprobar "${expense.concept}" '
          'por \$${expense.amount.toStringAsFixed(2)}';
    }

    return next.approve(expense);
  }

  String get name;

  bool canApprove(Expense expense);
}

class Supervisor extends Approver {
  @override
  String get name => 'Supervisor';

  @override
  bool canApprove(Expense expense) => expense.amount <= 100;
}

class Manager extends Approver {
  @override
  String get name => 'Gerente';

  @override
  bool canApprove(Expense expense) => expense.amount <= 1000;
}

class Director extends Approver {
  @override
  String get name => 'Director';

  @override
  bool canApprove(Expense expense) => true;
}

void run() {
  final supervisor = Supervisor();
  final manager = Manager();
  final director = Director();

  supervisor.setNext(manager).setNext(director);

  final expenses = <Expense>[
    const Expense('Material de oficina', 80),
    const Expense('Capacitación', 500),
    const Expense('Equipo nuevo', 5000),
  ];

  for (final expense in expenses) {
    print(supervisor.approve(expense));
  }
}

void main() => run();
