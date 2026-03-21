part of 'generated.dart';

class UpdateHabitVariablesBuilder {
  String id;
  String name;
  String description;
  int goalDaysPerWeek;
  String priority;
  double colorHex;

  final FirebaseDataConnect _dataConnect;
  UpdateHabitVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.description,required  this.goalDaysPerWeek,required  this.priority,required  this.colorHex,});
  Deserializer<UpdateHabitData> dataDeserializer = (dynamic json)  => UpdateHabitData.fromJson(jsonDecode(json));
  Serializer<UpdateHabitVariables> varsSerializer = (UpdateHabitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateHabitData, UpdateHabitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateHabitData, UpdateHabitVariables> ref() {
    UpdateHabitVariables vars= UpdateHabitVariables(id: id,name: name,description: description,goalDaysPerWeek: goalDaysPerWeek,priority: priority,colorHex: colorHex,);
    return _dataConnect.mutation("UpdateHabit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateHabitHabitUpdate {
  final String id;
  UpdateHabitHabitUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateHabitHabitUpdate otherTyped = other as UpdateHabitHabitUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateHabitHabitUpdate({
    required this.id,
  });
}

@immutable
class UpdateHabitData {
  final UpdateHabitHabitUpdate? habit_update;
  UpdateHabitData.fromJson(dynamic json):
  
  habit_update = json['habit_update'] == null ? null : UpdateHabitHabitUpdate.fromJson(json['habit_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateHabitData otherTyped = other as UpdateHabitData;
    return habit_update == otherTyped.habit_update;
    
  }
  @override
  int get hashCode => habit_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (habit_update != null) {
      json['habit_update'] = habit_update!.toJson();
    }
    return json;
  }

  UpdateHabitData({
    this.habit_update,
  });
}

@immutable
class UpdateHabitVariables {
  final String id;
  final String name;
  final String description;
  final int goalDaysPerWeek;
  final String priority;
  final double colorHex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateHabitVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  goalDaysPerWeek = nativeFromJson<int>(json['goalDaysPerWeek']),
  priority = nativeFromJson<String>(json['priority']),
  colorHex = nativeFromJson<double>(json['colorHex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateHabitVariables otherTyped = other as UpdateHabitVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    goalDaysPerWeek == otherTyped.goalDaysPerWeek && 
    priority == otherTyped.priority && 
    colorHex == otherTyped.colorHex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, goalDaysPerWeek.hashCode, priority.hashCode, colorHex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['goalDaysPerWeek'] = nativeToJson<int>(goalDaysPerWeek);
    json['priority'] = nativeToJson<String>(priority);
    json['colorHex'] = nativeToJson<double>(colorHex);
    return json;
  }

  UpdateHabitVariables({
    required this.id,
    required this.name,
    required this.description,
    required this.goalDaysPerWeek,
    required this.priority,
    required this.colorHex,
  });
}

