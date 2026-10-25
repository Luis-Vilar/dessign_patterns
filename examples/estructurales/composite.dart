// Composite: trata un objeto individual y un grupo de objetos de la misma
// forma, para poder recorrer estructuras en árbol.

abstract class FileSystemEntry {
  String get name;
  int sizeInKb();

  // La misma operación para una hoja y para una carpeta.
  String describe([String prefix = '']);
}

class DocumentFile implements FileSystemEntry {
  @override
  final String name;

  final int size;

  DocumentFile(this.name, this.size);

  @override
  int sizeInKb() => size;

  @override
  String describe([String prefix = '']) => '$prefix$name (${sizeInKb()} KB)';
}

class Folder implements FileSystemEntry {
  @override
  final String name;

  final List<FileSystemEntry> _children = <FileSystemEntry>[];

  Folder(this.name);

  void add(FileSystemEntry entry) {
    _children.add(entry);
  }

  @override
  int sizeInKb() {
    var total = 0;
    for (final child in _children) {
      total += child.sizeInKb();
    }
    return total;
  }

  @override
  String describe([String prefix = '']) {
    final buffer = StringBuffer('$prefix$name/\n');
    for (final child in _children) {
      buffer.writeln(child.describe('$prefix  '));
    }
    return buffer.toString().trimRight();
  }
}

void run() {
  final root = Folder('proyecto');
  final source = Folder('src');
  source.add(DocumentFile('main.dart', 12));
  source.add(DocumentFile('utils.dart', 8));

  final assets = Folder('assets');
  assets.add(DocumentFile('logo.png', 250));

  root.add(source);
  root.add(assets);
  root.add(DocumentFile('README.md', 3));

  print(root.describe());
  print('Tamaño total: ${root.sizeInKb()} KB');
}

void main() => run();
