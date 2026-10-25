# 🏭 Builder (Patrón creacional)

<!-- example: examples/creacionales/builder.dart -->

## La tienda de computadoras de Hugo

Hugo arma computadoras a medida. Al principio su clase `Computer` tenía un
constructor con todos los datos juntos:

```text
Computer("Ryzen 7", 32, "SSD 1 TB", true, false, true, "RTX 4070")
```

Un día un cliente pidió una máquina con WiFi y sin tarjeta gráfica dedicada.
Hugo escribió los valores en el orden equivocado y entregó exactamente lo
contrario. Nadie lo notó hasta que el cliente encendió el equipo.

El problema no era Hugo: era el constructor. Con tantos parámetros posicionales
y banderas `true/false`, el código deja de leerse y empieza a adivinarse. Y si
el cliente quería una máquina sencilla, había que rellenar igual todos los
campos que no usaba.

Hugo cambió el proceso. Ahora el cliente habla con un **armador**:

```text
"Ponle un Ryzen 7" → "Súbele a 32 GB de RAM" → "Agrega una RTX 4070" → "Listo"
```

El armador guarda las decisiones, valida lo que no tiene sentido y, al final,
entrega una computadora terminada que ya no se puede modificar. Ese es el
**Builder**: construir paso a paso, con nombres claros, y entregar un objeto
final coherente.

## La idea en una frase

Separa **cómo se arma** un objeto de **cómo se usa**, para que armarlo sea
legible, validable y opcional paso por paso.

## ¿Cuándo usarlo?

- El objeto tiene muchos campos opcionales o combinaciones que deben validarse.
- Quieres una API fluida y legible en el punto de creación.
- El mismo proceso de armado sirve para varias recetas (por ejemplo, una PC de
  oficina y una de juegos).

## ¿Cuándo NO usarlo?

- El objeto tiene dos o tres campos: los parámetros con nombre de Dart ya son
  claros y no necesitas otra clase.
- No hay reglas que validar ni pasos que ordenar.
- Solo quieres copiar un objeto existente cambiando un campo: `copyWith` es más
  directo.

## Implementación en Dart

```dart
// Builder: construye un objeto complejo paso a paso y entrega un resultado
// inmutable y validado.

class Computer {
  final String cpu;
  final int ramGb;
  final String storage;
  final String? gpu;
  final bool wifi;

  const Computer._({
    required this.cpu,
    required this.ramGb,
    required this.storage,
    this.gpu,
    required this.wifi,
  });

  void describe() {
    final gpuText = gpu ?? 'integrada';
    final wifiText = wifi ? 'sí' : 'no';
    print('PC: $cpu | ${ramGb} GB RAM | $storage | '
        'GPU: $gpuText | WiFi: $wifiText');
  }
}

class ComputerBuilder {
  String _cpu = 'Intel Core i3';
  int _ramGb = 8;
  String _storage = 'SSD 256 GB';
  String? _gpu;
  bool _wifi = false;

  ComputerBuilder cpu(String value) {
    _cpu = value;
    return this;
  }

  ComputerBuilder ram(int value) {
    if (value < 4) {
      throw ArgumentError('La RAM debe ser de al menos 4 GB');
    }
    _ramGb = value;
    return this;
  }

  ComputerBuilder storage(String value) {
    _storage = value;
    return this;
  }

  ComputerBuilder gpu(String value) {
    _gpu = value;
    return this;
  }

  ComputerBuilder withWifi() {
    _wifi = true;
    return this;
  }

  Computer build() {
    return Computer._(
      cpu: _cpu,
      ramGb: _ramGb,
      storage: _storage,
      gpu: _gpu,
      wifi: _wifi,
    );
  }
}

// Director: conoce dos recetas completas y reutiliza el mismo builder.
class ComputerStore {
  Computer officePc() {
    return ComputerBuilder()
        .cpu('Intel Core i3')
        .ram(8)
        .storage('SSD 256 GB')
        .withWifi()
        .build();
  }

  Computer gamingPc() {
    return ComputerBuilder()
        .cpu('AMD Ryzen 7')
        .ram(32)
        .storage('SSD 1 TB')
        .gpu('RTX 4070')
        .withWifi()
        .build();
  }
}

void run() {
  final store = ComputerStore();
  store.officePc().describe();
  store.gamingPc().describe();

  // También se puede armar una configuración a medida.
  ComputerBuilder()
      .cpu('Apple M3')
      .ram(16)
      .storage('SSD 512 GB')
      .build()
      .describe();

  try {
    ComputerBuilder().ram(2);
  } on ArgumentError catch (error) {
    print('Error esperado: ${error.message}');
  }
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/creacionales/builder.dart
```

```text
PC: Intel Core i3 | 8 GB RAM | SSD 256 GB | GPU: integrada | WiFi: sí
PC: AMD Ryzen 7 | 32 GB RAM | SSD 1 TB | GPU: RTX 4070 | WiFi: sí
PC: Apple M3 | 16 GB RAM | SSD 512 GB | GPU: integrada | WiFi: no
Error esperado: La RAM debe ser de al menos 4 GB
```

`build()` es el único punto donde se crea el objeto. Antes de eso, el armador
es solo un borrador; después, la computadora ya no cambia.

## Se parece a...

- **Factory Method:** crea el producto en un solo paso. Builder lo arma en
  varios y permite validar durante el camino.
- **Prototype:** parte de un objeto existente y lo clona. Builder parte de
  cero.
- **Abstract Factory:** crea familias de productos; Builder crea **un** objeto
  complejo.

## En Flutter

Tres aclaraciones para no confundir nombres con patrones:

- `ListView.builder` **no** es el patrón Builder. El "builder" de ese nombre es
  una función que Flutter llama para crear cada elemento bajo demanda; sirve
  para no construir toda la lista de golpe.
- `ThemeData.copyWith` **no** es Builder: copia un objeto inmutable cambiando
  algunos campos.
- El widget `Builder` de Flutter tampoco es este patrón: es un widget que
  recibe una función `WidgetBuilder` y la ejecuta con el `BuildContext`.

## Resumen

- El builder acumula decisiones y valida antes de entregar el objeto.
- La API fluida hace legible una creación con muchos campos.
- El objeto final nace inmutable, en un único `build()`.
