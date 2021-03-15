import 'package:dartson/dartson.dart';
import 'package:test/test.dart';

import 'models/name.dart';
import 'models/person.dart';

void main() {
  group('A group of tests', () {
    test('Serialize Test', () {
      var person = Person();
      person.name = Name();

      person.age = 24;
      person.name.firstName = 'Niel';
      //person.name.middleName = 'Patrick';
      person.name.lastName = 'Harris';
      person.emails = ['email1', 'email2', 'email3'];

      var serializedObject = Dartson.SerializeObject(person);

      print(serializedObject);
    });

    test('Deserialize Test', () {
      var person = Person();
      person.name = Name();

      person.age = 24;
      person.name.firstName = 'Niel';
      person.name.middleName = 'Patrick';
      person.name.lastName = 'Harris';
      person.emails = ['email1', 'email2', 'email3'];


      var json = Dartson.SerializeObject(person);

      var result = Dartson.DeserializeObject<Person>(json);

      print(result.name.firstName);

      expect(result.name.firstName == person.name.firstName, isTrue);
      expect(result.name.lastName == person.name.lastName, isTrue);
      expect(result.age == person.age, isTrue);
    });
  });
}
