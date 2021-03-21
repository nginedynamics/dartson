import 'dart:ffi';

class TypeService {
    static bool IsSimpleType(Type type){
      if (type == String || type == int ||type == bool || type == double || type == num || type == Float) {
        return true;
      } else {
        return false;
      }
    }
}