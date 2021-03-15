import 'dart:convert';
import 'dart:mirrors';

import 'activatorService.dart';

class SerializationService {
    Map<String, dynamic> SerializeProperties(dynamic object, [int iteration]) {
      var mirror = reflect(object);
      var properties = mirror.type.declarations;
      var jsonProperties = <String, dynamic>{};

      properties.forEach((key, value) {
        var classObject = false;
        if (value.owner.simpleName == mirror.type.simpleName && value.simpleName != mirror.type.simpleName) {
          var propertyMirror = reflect(mirror.getField(value.simpleName).reflectee);
          propertyMirror.type.declarations.forEach((subKey, subValue) {
            if (
            subValue.owner.simpleName == propertyMirror.type.simpleName
                && subValue.simpleName != propertyMirror.type.simpleName
                && !MirrorSystem.getName(subValue.owner.simpleName).startsWith('_')
                && MirrorSystem.getName(subValue.owner.simpleName) != 'Null'
            )
            {
              classObject = true;
            }
          });

          if (classObject) {
            if (iteration == null) {
                iteration = 0;
            } else {
              iteration++;
            }
            jsonProperties.addAll({ MirrorSystem.getName(value.simpleName): SerializeProperties(mirror.getField(value.simpleName).reflectee, iteration) });
          } else {
            jsonProperties.addAll({ MirrorSystem.getName(value.simpleName): mirror.getField(value.simpleName).reflectee });
          }
        }
      });

      return jsonProperties;
    }

    dynamic DeserializeProperties(String json, Type type, [Map<String, dynamic> jsonProperties]) {
      var mirror = reflectClass(type);
      Symbol constructorSymbol;

      for (var declaration in mirror.declarations.values) {
        if (declaration is MethodMirror && declaration.isConstructor) {
          constructorSymbol = declaration.constructorName;
        }
      }

      var instance = ActivatorService.createInstance(type, constructorSymbol);
      var mirrorInstance = reflect(instance);

      jsonProperties ??= jsonDecode(json) as Map<String, dynamic>;

      jsonProperties.forEach((key, value) {
        var mapType = <String, dynamic>{}.runtimeType;
        var listType = [].runtimeType;
        VariableMirror propertyMirror = mirror.declarations[MirrorSystem.getSymbol(key)];
        var propertyType = propertyMirror.type.reflectedType;
        if (value.runtimeType == mapType) {
          mirrorInstance.setField(MirrorSystem.getSymbol(key), DeserializeProperties('', propertyType, value));
        } else if (value.runtimeType == listType) {
          mirrorInstance.setField(MirrorSystem.getSymbol(key), value as List);
        } else {
          mirrorInstance.setField(MirrorSystem.getSymbol(key), value);
        }
      });

      return mirrorInstance.reflectee;
    }
}