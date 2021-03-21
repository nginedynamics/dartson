import 'dart:convert';
import 'dart:mirrors';

import 'package:dartson/src/typeService.dart';

import 'activatorService.dart';

class SerializationService {
    Map<String, dynamic> SerializeProperties(dynamic object, [int iteration]) {
      var mirror = reflect(object);
      var properties = mirror.type.declarations;
      var jsonProperties = <String, dynamic>{};

      properties.forEach((key, value) {
        var classObject = false;
        var added = false;
        if (value.owner.simpleName == mirror.type.simpleName && value.simpleName != mirror.type.simpleName) {
          InstanceMirror propertyMirror = reflect(mirror.getField(value.simpleName).reflectee);

          if (propertyMirror.type.isSubclassOf(reflectClass([].runtimeType)) && propertyMirror.hasReflectee && propertyMirror.reflectee != null) {
              if (!TypeService.IsSimpleType(propertyMirror.type.typeArguments.first.reflectedType)) {
                var listObject = [];
                  for (var item in propertyMirror.reflectee) {
                    if (iteration == null) {
                      iteration = 0;
                    } else {
                      iteration++;
                    }
                    listObject.add(SerializeProperties(item, iteration));
                  }

                  jsonProperties.addAll({ MirrorSystem.getName(value.simpleName): listObject});
                  added = true;
              }
          }

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
          } else if (!added) {
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
        Symbol propertySymbol;
        VariableMirror propertyMirror = mirror.declarations[MirrorSystem.getSymbol(key)];
        var propertyType = propertyMirror.type.reflectedType;
        ClassMirror propertyTypeClassMirror = reflectClass(propertyType);
        for (var declaration in propertyTypeClassMirror.declarations.values) {
          if (declaration is MethodMirror && declaration.isConstructor) {
            propertySymbol = declaration.constructorName;
          }
        }
        var mapType = <String, dynamic>{}.runtimeType;
        var listType = [].runtimeType;


        if (value.runtimeType == mapType) {
          mirrorInstance.setField(MirrorSystem.getSymbol(key), DeserializeProperties('', propertyType, value));
        } else if (value.runtimeType == listType) {
          var newValue = ActivatorService.createInstance(propertyType) as List;
          for (var item in value) {
            if (item.runtimeType == <String, dynamic>{}.runtimeType) {
                newValue.add(DeserializeProperties('', propertyMirror.type.typeArguments.first.reflectedType, item));
            } else {
              newValue.add(item);
            }
          }
          mirrorInstance.setField(MirrorSystem.getSymbol(key), newValue);
        } else {
          mirrorInstance.setField(MirrorSystem.getSymbol(key), value);
        }
      });

      return mirrorInstance.reflectee;
    }
}