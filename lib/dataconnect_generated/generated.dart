library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'get_my_habits.dart';

part 'create_habit.dart';







class ExampleConnector {
  
  
  GetMyHabitsVariablesBuilder getMyHabits () {
    return GetMyHabitsVariablesBuilder(dataConnect, );
  }
  
  
  CreateHabitVariablesBuilder createHabit ({required String id, required String name, required String description, required bool isHabitMode, required Timestamp startDate, required int goalDaysPerWeek, required String priority, required double colorHex, required bool isArchived, }) {
    return CreateHabitVariablesBuilder(dataConnect, id: id,name: name,description: description,isHabitMode: isHabitMode,startDate: startDate,goalDaysPerWeek: goalDaysPerWeek,priority: priority,colorHex: colorHex,isArchived: isArchived,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'improov',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
