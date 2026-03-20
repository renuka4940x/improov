part of 'generated.dart';

class CreateHabitVariablesBuilder {
  String id;
  String name;
  String description;
  bool isHabitMode;
  Timestamp startDate;
  int goalDaysPerWeek;
  String priority;
  double colorHex;
  bool isArchived;

  final FirebaseDataConnect _dataConnect;
  CreateHabitVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.description,required  this.isHabitMode,required  this.startDate,required  this.goalDaysPerWeek,required  this.priority,required  this.colorHex,required  this.isArchived,});
  Deserializer<CreateHabitData> dataDeserializer = (dynamic json)  => CreateHabitData.fromJson(jsonDecode(json));
  Serializer<CreateHabitVariables> varsSerializer = (CreateHabitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateHabitData, CreateHabitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateHabitData, CreateHabitVariables> ref() {
    CreateHabitVariables vars= CreateHabitVariables(id: id,name: name,description: description,isHabitMode: isHabitMode,startDate: startDate,goalDaysPerWeek: goalDaysPerWeek,priority: priority,colorHex: colorHex,isArchived: isArchived,);
    return _dataConnect.mutation("CreateHabit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateHabitHabitInsert {
  final String id;
  CreateHabitHabitInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateHabitHabitInsert otherTyped = other as CreateHabitHabitInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateHabitHabitInsert({
    required this.id,
  });
}

@immutable
class CreateHabitData {
  final CreateHabitHabitInsert habit_insert;
  CreateHabitData.fromJson(dynamic json):
  
  habit_insert = CreateHabitHabitInsert.fromJson(json['habit_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateHabitData otherTyped = other as CreateHabitData;
    return habit_insert == otherTyped.habit_insert;
    
  }
  @override
  int get hashCode => habit_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['habit_insert'] = habit_insert.toJson();
    return json;
  }

  CreateHabitData({
    required this.habit_insert,
  });
}

@immutable
class CreateHabitVariables {
  final String id;
  final String name;
  final String description;
  final bool isHabitMode;
  final Timestamp startDate;
  final int goalDaysPerWeek;
  final String priority;
  final double colorHex;
  final bool isArchived;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateHabitVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  isHabitMode = nativeFromJson<bool>(json['isHabitMode']),
  startDate = Timestamp.fromJson(json['startDate']),
  goalDaysPerWeek = nativeFromJson<int>(json['goalDaysPerWeek']),
  priority = nativeFromJson<String>(json['priority']),
  colorHex = nativeFromJson<double>(json['colorHex']),
  isArchived = nativeFromJson<bool>(json['isArchived']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateHabitVariables otherTyped = other as CreateHabitVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    isHabitMode == otherTyped.isHabitMode && 
    startDate == otherTyped.startDate && 
    goalDaysPerWeek == otherTyped.goalDaysPerWeek && 
    priority == otherTyped.priority && 
    colorHex == otherTyped.colorHex && 
    isArchived == otherTyped.isArchived;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, isHabitMode.hashCode, startDate.hashCode, goalDaysPerWeek.hashCode, priority.hashCode, colorHex.hashCode, isArchived.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['isHabitMode'] = nativeToJson<bool>(isHabitMode);
    json['startDate'] = startDate.toJson();
    json['goalDaysPerWeek'] = nativeToJson<int>(goalDaysPerWeek);
    json['priority'] = nativeToJson<String>(priority);
    json['colorHex'] = nativeToJson<double>(colorHex);
    json['isArchived'] = nativeToJson<bool>(isArchived);
    return json;
  }

  CreateHabitVariables({
    required this.id,
    required this.name,
    required this.description,
    required this.isHabitMode,
    required this.startDate,
    required this.goalDaysPerWeek,
    required this.priority,
    required this.colorHex,
    required this.isArchived,
  });
}

