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
