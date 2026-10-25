# Cómo leer esta guía

## Para quién es

Para quien ya sabe escribir clases en Dart y quiere entender los patrones de
diseño sin leer un tratado. No hace falta experiencia profesional ni conocer
Flutter.

## Cómo está organizada

Los patrones se agrupan en tres familias, igual que en el catálogo original:

- **Creacionales (5):** resuelven cómo crear objetos.
- **Estructurales (7):** resuelven cómo componer objetos y clases.
- **De comportamiento (11):** resuelven cómo se comunican los objetos.

Cada documento sigue siempre el mismo orden:

1. Una historia cotidiana.
2. La idea del patrón en una frase.
3. Cuándo usarlo y cuándo no.
4. La implementación completa en Dart.
5. La salida real del ejemplo.
6. La diferencia con el patrón que más se le parece.
7. Una mención a Flutter, solo cuando el patrón aparece de verdad.
8. Un resumen de tres viñetas.

## El código es ejecutable

Cada documento contiene exactamente el mismo código que su archivo en
`examples/`. Puedes ejecutarlo así:

```bash
dart run examples/creacionales/factory_method.dart
```

Y comprobar que todo el material está sincronizado y funciona con:

```bash
dart analyze
dart run tool/run_examples.dart
dart run tool/check_docs.dart
```

## Una advertencia honesta

Un patrón no es una meta. Es una solución concreta a un problema concreto. Si
el problema no existe todavía, aplicar el patrón solo agrega clases y
confusión. Por eso cada documento incluye una sección de **cuándo no usarlo**:
esa sección vale tanto como la implementación.

## Licencia

El código está bajo MIT y el texto bajo CC BY 4.0. Los nombres y la estructura
de los patrones provienen del catálogo GoF; los relatos y ejemplos son
originales.
