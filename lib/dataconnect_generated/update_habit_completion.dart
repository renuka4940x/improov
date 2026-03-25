part of 'generated.dart';

class UpdateHabitCompletionVariablesBuilder {
  String id;
  int currentStreak;
  int bestStreak;
  List<String> completedDays;

  final FirebaseDataConnect _dataConnect;
  UpdateHabitCompletionVariablesBuilder(this._dataConnect, {required  this.id,required  this.currentStreak,required  this.bestStreak,required  this.completedDays,});
  Deserializer<UpdateHabitCompletionData> dataDeserializer = (dynamic json)  => UpdateHabitCompletionData.fromJson(jsonDecode(json));
  Serializer<UpdateHabitCompletionVariables> varsSerializer = (UpdateHabitCompletionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateHabitCompletionData, UpdateHabitCompletionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateHabitCompletionData, UpdateHabitCompletionVariables> ref() {
    UpdateHabitCompletionVariables vars= UpdateHabitCompletionVariables(id: id,currentStreak: currentStreak,bestStreak: bestStreak,completedDays: completedDays,);
    return _dataConnect.mutation("UpdateHabitCompletion", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateHabitCompletionData {
  final int habit_updateMany;
  UpdateHabitCompletionData.fromJson(dynamic json):
  
  habit_updateMany = nativeFromJson<int>(json['habit_updateMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateHabitCompletionData otherTyped = other as UpdateHabitCompletionData;
    return habit_updateMany == otherTyped.habit_updateMany;
    
  }
  @override
  int get hashCode => habit_updateMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['habit_updateMany'] = nativeToJson<int>(habit_updateMany);
    return json;
  }

  UpdateHabitCompletionData({
    required this.habit_updateMany,
  });
}

@immutable
class UpdateHabitCompletionVariables {
  final String id;
  final int currentStreak;
  final int bestStreak;
  final List<String> completedDays;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateHabitCompletionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  currentStreak = nativeFromJson<int>(json['currentStreak']),
  bestStreak = nativeFromJson<int>(json['bestStreak']),
  completedDays = (json['completedDays'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateHabitCompletionVariables otherTyped = other as UpdateHabitCompletionVariables;
    return id == otherTyped.id && 
    currentStreak == otherTyped.currentStreak && 
    bestStreak == otherTyped.bestStreak && 
    completedDays == otherTyped.completedDays;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, currentStreak.hashCode, bestStreak.hashCode, completedDays.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['currentStreak'] = nativeToJson<int>(currentStreak);
    json['bestStreak'] = nativeToJson<int>(bestStreak);
    json['completedDays'] = completedDays.map((e) => nativeToJson<String>(e)).toList();
    return json;
  }

  UpdateHabitCompletionVariables({
    required this.id,
    required this.currentStreak,
    required this.bestStreak,
    required this.completedDays,
  });
}

