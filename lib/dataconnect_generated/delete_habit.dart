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
class DeleteHabitData {
  final int habit_deleteMany;
  DeleteHabitData.fromJson(dynamic json):
  
  habit_deleteMany = nativeFromJson<int>(json['habit_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteHabitData otherTyped = other as DeleteHabitData;
    return habit_deleteMany == otherTyped.habit_deleteMany;
    
  }
  @override
  int get hashCode => habit_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['habit_deleteMany'] = nativeToJson<int>(habit_deleteMany);
    return json;
  }

  DeleteHabitData({
    required this.habit_deleteMany,
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

