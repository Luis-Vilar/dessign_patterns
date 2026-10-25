// Prototype: crea objetos nuevos clonando uno existente.
// La clonación debe ser profunda para que los objetos no compartan estado.

abstract class DocumentTemplate {
  String get title;
  List<String> get clauses;

  DocumentTemplate clone();
}

class ContractTemplate implements DocumentTemplate {
  @override
  String title;

  @override
  final List<String> clauses;

  ContractTemplate(this.title, List<String> clauses)
      : clauses = List.of(clauses);

  ContractTemplate._(this.title, this.clauses);

  @override
  ContractTemplate clone() => ContractTemplate._(title, List.of(clauses));

  void describe() {
    print(title);
    for (final clause in clauses) {
      print('  - $clause');
    }
  }
}

void run() {
  final original = ContractTemplate('Contrato de alquiler', <String>[
    'El inquilino paga el alquiler el día 5.',
    'El depósito es de un mes.',
    'El contrato dura doce meses.',
  ]);

  final copy = original.clone();
  copy.title = 'Contrato de alquiler - Local comercial';
  copy.clauses.add('El local se usa solo para fines comerciales.');

  print('Original:');
  original.describe();

  print('\nCopia:');
  copy.describe();

  print('\n¿Son el mismo objeto? ${identical(original, copy)}');
  print('¿Comparten la lista? ${identical(original.clauses, copy.clauses)}');
}

void main() => run();
