# 🏭 Prototype (Patrón creacional)

<!-- example: examples/creacionales/prototype.dart -->

## La notaría de Elena

Elena prepara contratos de alquiler. La mayoría son casi iguales: cambian el
nombre del inquilino, la dirección y algún que otro detalle. Al principio
escribía cada contrato desde cero, y siempre se le escapaba alguna cláusula.

Un día empezó a guardar un contrato base y, para cada cliente, hacía una
**copia** y editaba solo lo necesario. El trabajo se volvió más rápido y más
seguro. Pero descubrió un detalle: si las dos copias compartían la misma hoja
de cláusulas, al agregar una cláusula en una, aparecía también en la otra.

Eso es lo que hay que cuidar al clonar: el clon debe ser independiente. En un
contrato, la lista de cláusulas tiene que copiarse también, no solo la
referencia. A eso se le llama **clonación profunda**.

El patrón **Prototype** consiste precisamente en eso: crear objetos nuevos a
partir de un ejemplar existente, sin volver a construirlos desde cero.

## La idea en una frase

En lugar de construir un objeto desde cero, **copia uno que ya funciona** y
cambia solo lo que necesitas.

## ¿Cuándo usarlo?

- Crear el objeto desde cero es costoso (consulta a una base, cálculo pesado,
  configuración larga).
- Necesitas muchos objetos parecidos que difieren en pocos campos.
- Quieres evitar una explosión de subclases para cada combinación posible.

## ¿Cuándo NO usarlo?

- El objeto es simple: un constructor con parámetros con nombre es más claro.
- Copiar es ambiguo o peligroso: conexiones, archivos abiertos o recursos del
  sistema no se pueden duplicar sin más.
- Los objetos tienen referencias circulares o estructuras muy anidadas: una
  copia profunda mal hecha puede ser peor que construir de nuevo.

## Implementación en Dart

```dart
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
```

## 🚀 Ejemplo de uso

```bash
dart run examples/creacionales/prototype.dart
```

```text
Original:
Contrato de alquiler
  - El inquilino paga el alquiler el día 5.
  - El depósito es de un mes.
  - El contrato dura doce meses.

Copia:
Contrato de alquiler - Local comercial
  - El inquilino paga el alquiler el día 5.
  - El depósito es de un mes.
  - El contrato dura doce meses.
  - El local se usa solo para fines comerciales.

¿Son el mismo objeto? false
¿Comparten la lista? false
```

Las dos últimas líneas son la prueba: son objetos distintos y sus listas
también lo son. Si `clone()` hiciera `ContractTemplate._(title, clauses)` sin
`List.of`, la copia compartiría la lista y el original cambiaría por accidente.

## Se parece a...

- **Builder:** construye desde cero, paso a paso. Prototype parte de algo que
  ya existe.
- **Factory Method:** crea un producto nuevo según un tipo. Prototype no
  pregunta el tipo: copia un ejemplar.
- **`copyWith`:** es un primo cercano. Copia un objeto inmutable cambiando
  algunos campos, pero no suele resolver el problema de las referencias
  internas.

## En Flutter

Los widgets son inmutables y Flutter no los clona para reutilizarlos: los
vuelve a construir cuando hace falta. Lo que sí verás a diario son métodos
`copyWith` en clases de configuración como `ThemeData`; son una forma de copia
con cambios, útil para no reconstruir todo el objeto a mano.

## Resumen

- Prototype crea a partir de un ejemplar, no de una clase.
- La copia debe ser profunda si el objeto guarda listas u otros objetos.
- Es útil cuando construir desde cero es caro o repetitivo.
