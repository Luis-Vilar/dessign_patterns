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
