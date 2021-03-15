import 'dart:mirrors';

class ActivatorService {
static dynamic createInstance(Type type, [Symbol constructor, List arguments, Map<Symbol, dynamic> namedArguments]) {
    if (type == null) {
      throw new ArgumentError("type: $type");
    }

    constructor ??= const Symbol("");

    arguments ??= const [];

    namedArguments ??= const <Symbol, dynamic>{};

    var typeMirror = reflectType(type);
    if (typeMirror is ClassMirror) {
      return typeMirror.newInstance(constructor, arguments, namedArguments).reflectee;
    } else {
        throw new ArgumentError("Cannot create the instance of the type '$type'.");
    }
  }
}