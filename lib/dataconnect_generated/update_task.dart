part of 'generated.dart';

class UpdateTaskVariablesBuilder {
  String id;
  String name;
  String description;
  Timestamp dueDate;
  bool isCompleted;
  String priority;

  final FirebaseDataConnect _dataConnect;
  UpdateTaskVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.description,required  this.dueDate,required  this.isCompleted,required  this.priority,});
  Deserializer<UpdateTaskData> dataDeserializer = (dynamic json)  => UpdateTaskData.fromJson(jsonDecode(json));
  Serializer<UpdateTaskVariables> varsSerializer = (UpdateTaskVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateTaskData, UpdateTaskVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateTaskData, UpdateTaskVariables> ref() {
    UpdateTaskVariables vars= UpdateTaskVariables(id: id,name: name,description: description,dueDate: dueDate,isCompleted: isCompleted,priority: priority,);
    return _dataConnect.mutation("UpdateTask", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateTaskData {
  final int task_updateMany;
  UpdateTaskData.fromJson(dynamic json):
  
  task_updateMany = nativeFromJson<int>(json['task_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskData otherTyped = other as UpdateTaskData;
    return task_updateMany == otherTyped.task_updateMany;
    
  }
  @override
  int get hashCode => task_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['task_updateMany'] = nativeToJson<int>(task_updateMany);
    return json;
  }

  UpdateTaskData({
    required this.task_updateMany,
  });
}

@immutable
class UpdateTaskVariables {
  final String id;
  final String name;
  final String description;
  final Timestamp dueDate;
  final bool isCompleted;
  final String priority;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateTaskVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  dueDate = Timestamp.fromJson(json['dueDate']),
  isCompleted = nativeFromJson<bool>(json['isCompleted']),
  priority = nativeFromJson<String>(json['priority']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateTaskVariables otherTyped = other as UpdateTaskVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    dueDate == otherTyped.dueDate && 
    isCompleted == otherTyped.isCompleted && 
    priority == otherTyped.priority;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, dueDate.hashCode, isCompleted.hashCode, priority.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['dueDate'] = dueDate.toJson();
    json['isCompleted'] = nativeToJson<bool>(isCompleted);
    json['priority'] = nativeToJson<String>(priority);
    return json;
  }

  UpdateTaskVariables({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
  });
}

