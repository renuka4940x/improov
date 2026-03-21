part of 'generated.dart';

class CreateTaskVariablesBuilder {
  String id;
  String name;
  String description;
  Timestamp dueDate;
  bool isCompleted;
  Timestamp createdAt;
  String priority;

  final FirebaseDataConnect _dataConnect;
  CreateTaskVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.description,required  this.dueDate,required  this.isCompleted,required  this.createdAt,required  this.priority,});
  Deserializer<CreateTaskData> dataDeserializer = (dynamic json)  => CreateTaskData.fromJson(jsonDecode(json));
  Serializer<CreateTaskVariables> varsSerializer = (CreateTaskVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateTaskData, CreateTaskVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateTaskData, CreateTaskVariables> ref() {
    CreateTaskVariables vars= CreateTaskVariables(id: id,name: name,description: description,dueDate: dueDate,isCompleted: isCompleted,createdAt: createdAt,priority: priority,);
    return _dataConnect.mutation("CreateTask", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateTaskTaskInsert {
  final String id;
  CreateTaskTaskInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskTaskInsert otherTyped = other as CreateTaskTaskInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateTaskTaskInsert({
    required this.id,
  });
}

@immutable
class CreateTaskData {
  final CreateTaskTaskInsert task_insert;
  CreateTaskData.fromJson(dynamic json):
  
  task_insert = CreateTaskTaskInsert.fromJson(json['task_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskData otherTyped = other as CreateTaskData;
    return task_insert == otherTyped.task_insert;
    
  }
  @override
  int get hashCode => task_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['task_insert'] = task_insert.toJson();
    return json;
  }

  CreateTaskData({
    required this.task_insert,
  });
}

@immutable
class CreateTaskVariables {
  final String id;
  final String name;
  final String description;
  final Timestamp dueDate;
  final bool isCompleted;
  final Timestamp createdAt;
  final String priority;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateTaskVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  dueDate = Timestamp.fromJson(json['dueDate']),
  isCompleted = nativeFromJson<bool>(json['isCompleted']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  priority = nativeFromJson<String>(json['priority']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTaskVariables otherTyped = other as CreateTaskVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    dueDate == otherTyped.dueDate && 
    isCompleted == otherTyped.isCompleted && 
    createdAt == otherTyped.createdAt && 
    priority == otherTyped.priority;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, dueDate.hashCode, isCompleted.hashCode, createdAt.hashCode, priority.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['dueDate'] = dueDate.toJson();
    json['isCompleted'] = nativeToJson<bool>(isCompleted);
    json['createdAt'] = createdAt.toJson();
    json['priority'] = nativeToJson<String>(priority);
    return json;
  }

  CreateTaskVariables({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    required this.priority,
  });
}

