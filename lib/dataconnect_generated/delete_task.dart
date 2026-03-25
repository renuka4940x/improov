part of 'generated.dart';

class DeleteTaskVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteTaskVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteTaskData> dataDeserializer = (dynamic json)  => DeleteTaskData.fromJson(jsonDecode(json));
  Serializer<DeleteTaskVariables> varsSerializer = (DeleteTaskVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteTaskData, DeleteTaskVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteTaskData, DeleteTaskVariables> ref() {
    DeleteTaskVariables vars= DeleteTaskVariables(id: id,);
    return _dataConnect.mutation("DeleteTask", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteTaskData {
  final int task_deleteMany;
  DeleteTaskData.fromJson(dynamic json):
  
  task_deleteMany = nativeFromJson<int>(json['task_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteTaskData otherTyped = other as DeleteTaskData;
    return task_deleteMany == otherTyped.task_deleteMany;
    
  }
  @override
  int get hashCode => task_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['task_deleteMany'] = nativeToJson<int>(task_deleteMany);
    return json;
  }

  DeleteTaskData({
    required this.task_deleteMany,
  });
}

@immutable
class DeleteTaskVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteTaskVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteTaskVariables otherTyped = other as DeleteTaskVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteTaskVariables({
    required this.id,
  });
}

