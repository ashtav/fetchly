Fetchly is a lightweight Dart package designed to streamline your API interactions by simplifying the usage of the Dio HTTP client. It provides an easy-to-use, type-safe, and efficient wrapper around Dio, making your HTTP calls and response handling smooth and hassle-free.

## Usage

To use this plugin, add `fetchly` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).


### Example

```dart 

void main() {
  Fetchly.instance.init(
    baseUrl: 'https://dummyjson.com/',
    onRequest: (status, data){
      // listen request
    },
    onError: (e, s){
      // listen error
    }
  );

  runApp(const MyApp());
}

```

### Usage

To make API requests, extend the Fetchly class and define your methods like so:

```dart
import 'package:fetchly/fetchly.dart';

class TodoApi extends Fetchly {
  Future<ResHandler> getTodos() async => await get('todos');
}
```

In this code snippet, we're using Dart's mixin feature to create a reusable block of code named UseApi.

```dart
mixin UseApi {
    TodoApi todoApi = TodoApi();
    // other api
}

class MyClass with UseApi {
    Future getTodos() async {
        ResHandler res = await todoApi.getTodos();
    }
}
```

For more information and examples, see the [example](https://github.com/ashtav/fetchly/tree/master/example).
