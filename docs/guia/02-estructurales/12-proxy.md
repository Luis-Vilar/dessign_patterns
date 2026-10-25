# 🧱 Proxy (Patrón estructural)

<!-- example: examples/estructurales/proxy.dart -->

## La recepcionista del edificio

En un edificio de oficinas hay una recepcionista. Los visitantes no entran
directamente a las oficinas: pasan por recepción. Ella comprueba si tienen
permiso, anota quién ya vino antes y solo entonces los deja pasar.

Para el visitante, el trámite es el mismo de siempre: llegar y pedir acceso.
Para la oficina, hay una capa que controla el paso sin que el visitante tenga
que conocer las reglas internas. Además, si alguien ya fue autorizado hace un
rato, la recepcionista lo recuerda y no repite la llamada.

Eso es un **Proxy**: un sustituto que tiene la misma interfaz que el objeto
real y controla el acceso a él.

## La idea en una frase

Un intermediario con la misma interfaz que el objeto real, que decide si la
llamada pasa, se cachea o se rechaza.

## ¿Cuándo usarlo?

- Quieres controlar el acceso a un objeto costoso o sensible.
- Necesitas cargar algo pesado solo cuando de verdad se usa.
- Quieres agregar caché, registro o permisos sin tocar el objeto real.

## ¿Cuándo NO usarlo?

- No hay nada que controlar: solo agregas una capa y un salto mental.
- El cliente necesita la identidad exacta del objeto real.
- El "control" es en realidad comportamiento nuevo que debería estar en un
  Decorator.

## Implementación en Dart

```dart
// Proxy: un sustituto que controla el acceso al objeto real. Aquí agrega
// permisos y caché sin que el cliente cambie su forma de llamar.

abstract class DataService {
  String fetch(String id);
}

class RealDataService implements DataService {
  @override
  String fetch(String id) {
    print('Consultando el servicio externo por $id...');
    return 'Datos de $id';
  }
}

class CachedProxy implements DataService {
  final DataService _real;
  final String _user;
  final Map<String, String> _cache = <String, String>{};

  CachedProxy(this._real, this._user);

  @override
  String fetch(String id) {
    if (_user != 'admin') {
      return 'Acceso denegado para $_user';
    }

    final cached = _cache[id];
    if (cached != null) {
      return 'Caché: $cached';
    }

    final data = _real.fetch(id);
    _cache[id] = data;
    return data;
  }
}

void run() {
  final service = RealDataService();

  final admin = CachedProxy(service, 'admin');
  print(admin.fetch('cliente-1'));
  print(admin.fetch('cliente-1'));

  final guest = CachedProxy(service, 'invitado');
  print(guest.fetch('cliente-1'));
}

void main() => run();
```

## 🚀 Ejemplo de uso

```bash
dart run examples/estructurales/proxy.dart
```

```text
Consultando el servicio externo por cliente-1...
Datos de cliente-1
Caché: Datos de cliente-1
Acceso denegado para invitado
```

La segunda consulta no volvió a llamar al servicio real, y el invitado nunca
llegó a él. El cliente siguió usando `DataService` todo el tiempo.

## Se parece a...

- **Decorator:** comparte la interfaz y envuelve, pero su objetivo es **agregar
  comportamiento**; Proxy controla el acceso y normalmente hay uno solo.
- **Adapter:** cambia la interfaz para conectar dos mundos. Proxy conserva la
  interfaz.
- **Facade:** simplifica el acceso a un conjunto de subsistemas. Proxy
  representa **un** objeto y decide si la llamada pasa.

## En Flutter

Flutter usa la misma idea para las imágenes: `Image.network` no descarga ni
decodifica el archivo cada vez que se pinta, sino que pasa por un caché
intermedio. También hay carga diferida de recursos, donde el objeto real se
crea solo cuando se necesita.

## Resumen

- Proxy sustituye al objeto real y controla el acceso.
- Sirve para permisos, caché, carga diferida y registro.
- Mantiene la interfaz; no la transforma como un Adapter.
