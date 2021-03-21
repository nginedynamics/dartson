import 'package:dartson/dartson.dart';
import 'package:test/test.dart';

import 'models/friend.dart';
import 'models/name.dart';
import 'models/person.dart';

void main() {
  group('A group of tests', () {
    test('Serialize Test', () {
      var person = Person();
      person.name = Name();

      person.age = 24;
      person.name.firstName = 'Niel';
      person.birthDate = DateTime.now();
      //person.name.middleName = 'Patrick';
      person.name.lastName = 'Harris';
      person.emails = ['email1', 'email2', 'email3'];

      var friend1 = Friend();
      friend1.name = Name();
      friend1.name.firstName = 'Ted';
      friend1.name.lastName = 'Mosby';
      friend1.yearsKnownFor = 12;

      var friend2 = Friend();
      friend2.name = Name();
      friend2.name.firstName = 'Marshall';
      friend2.name.lastName = 'Erikson';
      friend2.yearsKnownFor = 9;

      person.friends = [friend1, friend2];

      var serializedObject = Dartson.SerializeObject(person);

      print(serializedObject);
    });

    test('Deserialize Test', () {
      var person = Person();
      person.name = Name();

      person.age = 24;
      person.birthDate = DateTime.now();
      person.name.firstName = 'Niel';
      //person.name.middleName = 'Patrick';
      person.name.lastName = 'Harris';
      person.emails = ['email1', 'email2', 'email3'];

      var friend1 = Friend();
      friend1.name = Name();
      friend1.name.firstName = 'Ted';
      friend1.name.lastName = 'Mosby';
      friend1.yearsKnownFor = 12;

      var friend2 = Friend();
      friend2.name = Name();
      friend2.name.firstName = 'Marshall';
      friend2.name.lastName = 'Erikson';
      friend2.yearsKnownFor = 9;

      person.friends = [friend1, friend2];


      var json = Dartson.SerializeObject(person);

      var result = Dartson.DeserializeObject<Person>(json);

      print(result.name.firstName);

      expect(result.name.firstName == person.name.firstName, isTrue);
      expect(result.name.lastName == person.name.lastName, isTrue);
      expect(result.age == person.age, isTrue);
    });
  });
}
