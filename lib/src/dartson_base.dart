// TODO: Put public facing types in this file.

import 'dart:convert';

import 'package:dartson/src/serializationService.dart';

/// Checks if you are awesome. Spoiler: you are.
class Dartson {
  static String SerializeObject(dynamic object){
    var serializationService = SerializationService();

    var jsonProperties = serializationService.SerializeProperties(object);

    return jsonEncode(jsonProperties);
  }

  static T DeserializeObject<T>(String json) {
    var serializationService = SerializationService();

    return serializationService.DeserializeProperties(json, T) as T;
  }
}