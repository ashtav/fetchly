Fetchly is a lightweight Dart package designed to streamline your API interactions, making the use of the Dio HTTP client simpler and more efficient. It offers an easy-to-use, type-safe, and efficient wrapper around Dio, ensuring your HTTP calls and response handling are smooth and hassle-free. Additionally, Fetchly enhances the development experience by displaying vital request information such as the path, method, duration, and payload, exclusively in development mode. This feature enables developers to easily monitor and understand the requests made within their application, aiding in effective debugging and development.

## Usage

To use this plugin, add `fetchly` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).


### Example

```dart 

void main() {
  Fetchly.init(
    baseUrl: 'https://dummyjson.com/',
    onRequest: (path, status, data){
      // listen request
    },
    onError: (e, s){
      // listen error
    },
    printType: PrintType.print // available: log, print, none
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
mixin Apis {
    TodoApi todoApi = TodoApi();
    // other api
}

class MyClass with Apis {
    Future getTodos() async {
        ResHandler res = await todoApi.getTodos();

        // to cancel request, use
        todoApi.cancel('todos'); // todos is path name
    }
}
```

### Methods

Provide some methods that you can use

```dart
// The `init` method is used to initialize Fetchly with a baseUrl and callbacks for onRequest and onError.
Fetchly.init(); 

// The `setHeader` method is used to set headers such as Authorization.
// You can also use dio.setToken('your_token') to set a token.
Fetchly.setHeader({});
```

For more information and examples, see the [example](https://github.com/ashtav/fetchly/tree/master/example).
