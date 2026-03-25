# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetMyHabits
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyHabits().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyHabitsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyHabits();
GetMyHabitsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyHabits().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String username = ...;
String email = ...;
String passwordHash = ...;
Timestamp createdAt = ...;
ExampleConnector.instance.createUser(
  username: username,
  email: email,
  passwordHash: passwordHash,
  createdAt: createdAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUser(
  username: username,
  email: email,
  passwordHash: passwordHash,
  createdAt: createdAt,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String username = ...;
String email = ...;
String passwordHash = ...;
Timestamp createdAt = ...;

final ref = ExampleConnector.instance.createUser(
  username: username,
  email: email,
  passwordHash: passwordHash,
  createdAt: createdAt,
).ref();
ref.execute();
```


### CreateHabit
#### Required Arguments
```dart
String id = ...;
String name = ...;
String description = ...;
bool isHabitMode = ...;
Timestamp startDate = ...;
int goalDaysPerWeek = ...;
String priority = ...;
double colorHex = ...;
bool isArchived = ...;
ExampleConnector.instance.createHabit(
  id: id,
  name: name,
  description: description,
  isHabitMode: isHabitMode,
  startDate: startDate,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
  isArchived: isArchived,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateHabitData, CreateHabitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createHabit(
  id: id,
  name: name,
  description: description,
  isHabitMode: isHabitMode,
  startDate: startDate,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
  isArchived: isArchived,
);
CreateHabitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String description = ...;
bool isHabitMode = ...;
Timestamp startDate = ...;
int goalDaysPerWeek = ...;
String priority = ...;
double colorHex = ...;
bool isArchived = ...;

final ref = ExampleConnector.instance.createHabit(
  id: id,
  name: name,
  description: description,
  isHabitMode: isHabitMode,
  startDate: startDate,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
  isArchived: isArchived,
).ref();
ref.execute();
```


### UpdateHabit
#### Required Arguments
```dart
String id = ...;
String name = ...;
String description = ...;
int goalDaysPerWeek = ...;
String priority = ...;
double colorHex = ...;
ExampleConnector.instance.updateHabit(
  id: id,
  name: name,
  description: description,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateHabitData, UpdateHabitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateHabit(
  id: id,
  name: name,
  description: description,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
);
UpdateHabitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String description = ...;
int goalDaysPerWeek = ...;
String priority = ...;
double colorHex = ...;

final ref = ExampleConnector.instance.updateHabit(
  id: id,
  name: name,
  description: description,
  goalDaysPerWeek: goalDaysPerWeek,
  priority: priority,
  colorHex: colorHex,
).ref();
ref.execute();
```


### UpdateHabitCompletion
#### Required Arguments
```dart
String id = ...;
int currentStreak = ...;
int bestStreak = ...;
String completedDays = ...;
ExampleConnector.instance.updateHabitCompletion(
  id: id,
  currentStreak: currentStreak,
  bestStreak: bestStreak,
  completedDays: completedDays,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateHabitCompletionData, UpdateHabitCompletionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateHabitCompletion(
  id: id,
  currentStreak: currentStreak,
  bestStreak: bestStreak,
  completedDays: completedDays,
);
UpdateHabitCompletionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int currentStreak = ...;
int bestStreak = ...;
String completedDays = ...;

final ref = ExampleConnector.instance.updateHabitCompletion(
  id: id,
  currentStreak: currentStreak,
  bestStreak: bestStreak,
  completedDays: completedDays,
).ref();
ref.execute();
```


### DeleteHabit
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteHabit(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteHabitData, DeleteHabitVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteHabit(
  id: id,
);
DeleteHabitData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteHabit(
  id: id,
).ref();
ref.execute();
```


### CreateTask
#### Required Arguments
```dart
String id = ...;
String name = ...;
String description = ...;
Timestamp dueDate = ...;
bool isCompleted = ...;
Timestamp createdAt = ...;
String priority = ...;
ExampleConnector.instance.createTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  createdAt: createdAt,
  priority: priority,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateTaskData, CreateTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  createdAt: createdAt,
  priority: priority,
);
CreateTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String description = ...;
Timestamp dueDate = ...;
bool isCompleted = ...;
Timestamp createdAt = ...;
String priority = ...;

final ref = ExampleConnector.instance.createTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  createdAt: createdAt,
  priority: priority,
).ref();
ref.execute();
```


### UpdateTask
#### Required Arguments
```dart
String id = ...;
String name = ...;
String description = ...;
Timestamp dueDate = ...;
bool isCompleted = ...;
String priority = ...;
ExampleConnector.instance.updateTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  priority: priority,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateTaskData, UpdateTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  priority: priority,
);
UpdateTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String description = ...;
Timestamp dueDate = ...;
bool isCompleted = ...;
String priority = ...;

final ref = ExampleConnector.instance.updateTask(
  id: id,
  name: name,
  description: description,
  dueDate: dueDate,
  isCompleted: isCompleted,
  priority: priority,
).ref();
ref.execute();
```


### DeleteTask
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteTask(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteTaskData, DeleteTaskVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteTask(
  id: id,
);
DeleteTaskData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteTask(
  id: id,
).ref();
ref.execute();
```

