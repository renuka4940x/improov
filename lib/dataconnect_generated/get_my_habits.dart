part of 'generated.dart';

class GetMyHabitsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyHabitsVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyHabitsData> dataDeserializer = (dynamic json)  => GetMyHabitsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyHabitsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyHabitsData, void> ref() {
    
    return _dataConnect.query("GetMyHabits", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyHabitsHabits {
  final String id;
  final String name;
  final String? description;
  final int goalDaysPerWeek;
  final Timestamp? reminderTime;
  final Timestamp startDate;
  GetMyHabitsHabits.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  goalDaysPerWeek = nativeFromJson<int>(json['goalDaysPerWeek']),
  reminderTime = json['reminderTime'] == null ? null : Timestamp.fromJson(json['reminderTime']),
  startDate = Timestamp.fromJson(json['startDate']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyHabitsHabits otherTyped = other as GetMyHabitsHabits;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    goalDaysPerWeek == otherTyped.goalDaysPerWeek && 
    reminderTime == otherTyped.reminderTime && 
    startDate == otherTyped.startDate;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, goalDaysPerWeek.hashCode, reminderTime.hashCode, startDate.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['goalDaysPerWeek'] = nativeToJson<int>(goalDaysPerWeek);
    if (reminderTime != null) {
      json['reminderTime'] = reminderTime!.toJson();
    }
    json['startDate'] = startDate.toJson();
    return json;
  }

  GetMyHabitsHabits({
    required this.id,
    required this.name,
    this.description,
    required this.goalDaysPerWeek,
    this.reminderTime,
    required this.startDate,
  });
}

@immutable
class GetMyHabitsData {
  final List<GetMyHabitsHabits> habits;
  GetMyHabitsData.fromJson(dynamic json):
  
  habits = (json['habits'] as List<dynamic>)
        .map((e) => GetMyHabitsHabits.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyHabitsData otherTyped = other as GetMyHabitsData;
    return habits == otherTyped.habits;
    
  }
  @override
  int get hashCode => habits.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['habits'] = habits.map((e) => e.toJson()).toList();
    return json;
  }

  GetMyHabitsData({
    required this.habits,
  });
}

