part of 'generated.dart';

class DeleteHabitVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteHabitVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteHabitData> dataDeserializer = (dynamic json)  => DeleteHabitData.fromJson(jsonDecode(json));
  Serializer<DeleteHabitVariables> varsSerializer = (DeleteHabitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteHabitData, DeleteHabitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteHabitData, DeleteHabitVariables> ref() {
    DeleteHabitVariables vars= DeleteHabitVariables(id: id,);
    return _dataConnect.mutation("DeleteHabit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteHabitHabitDelete {
  final String id;
  DeleteHabitHabitDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteHabitHabitDelete otherTyped = other as DeleteHabitHabitDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteHabitHabitDelete({
    required this.id,
  });
}

@immutable
class DeleteHabitData {
  final DeleteHabitHabitDelete? habit_delete;
  DeleteHabitData.fromJson(dynamic json):
  
  habit_delete = json['habit_delete'] == null ? null : DeleteHabitHabitDelete.fromJson(json['habit_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteHabitData otherTyped = other as DeleteHabitData;
    return habit_delete == otherTyped.habit_delete;
    
  }
  @override
  int get hashCode => habit_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (habit_delete != null) {
      json['habit_delete'] = habit_delete!.toJson();
    }
    return json;
  }

  DeleteHabitData({
    this.habit_delete,
  });
}

@immutable
class DeleteHabitVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteHabitVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteHabitVariables otherTyped = other as DeleteHabitVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteHabitVariables({
    required this.id,
  });
}

