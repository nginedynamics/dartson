A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:dartson/dartson.dart';

main() {
  const object = new MyObject();
  var json = Dartson.SerializeObject(object);
  
  var result = Dartson.DeserializeObject(json);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
