library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'get_my_habits.dart';

part 'create_habit.dart';

part 'update_habit.dart';

part 'update_habit_completion.dart';

part 'delete_habit.dart';

part 'create_task.dart';

part 'update_task.dart';

part 'delete_task.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser ({required String username, required String email, required String passwordHash, required Timestamp createdAt, }) {
    return CreateUserVariablesBuilder(dataConnect, username: username,email: email,passwordHash: passwordHash,createdAt: createdAt,);
  }
  
  
  GetMyHabitsVariablesBuilder getMyHabits () {
    return GetMyHabitsVariablesBuilder(dataConnect, );
  }
  
  
  CreateHabitVariablesBuilder createHabit ({required String id, required String name, required String description, required bool isHabitMode, required Timestamp startDate, required int goalDaysPerWeek, required String priority, required double colorHex, required bool isArchived, }) {
    return CreateHabitVariablesBuilder(dataConnect, id: id,name: name,description: description,isHabitMode: isHabitMode,startDate: startDate,goalDaysPerWeek: goalDaysPerWeek,priority: priority,colorHex: colorHex,isArchived: isArchived,);
  }
  
  
  UpdateHabitVariablesBuilder updateHabit ({required String id, required String name, required String description, required int goalDaysPerWeek, required String priority, required double colorHex, }) {
    return UpdateHabitVariablesBuilder(dataConnect, id: id,name: name,description: description,goalDaysPerWeek: goalDaysPerWeek,priority: priority,colorHex: colorHex,);
  }
  
  
  UpdateHabitCompletionVariablesBuilder updateHabitCompletion ({required String id, required int currentStreak, required int bestStreak, required List<String> completedDays, }) {
    return UpdateHabitCompletionVariablesBuilder(dataConnect, id: id,currentStreak: currentStreak,bestStreak: bestStreak,completedDays: completedDays,);
  }
  
  
  DeleteHabitVariablesBuilder deleteHabit ({required String id, }) {
    return DeleteHabitVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreateTaskVariablesBuilder createTask ({required String id, required String name, required String description, required Timestamp dueDate, required bool isCompleted, required Timestamp createdAt, required String priority, }) {
    return CreateTaskVariablesBuilder(dataConnect, id: id,name: name,description: description,dueDate: dueDate,isCompleted: isCompleted,createdAt: createdAt,priority: priority,);
  }
  
  
  UpdateTaskVariablesBuilder updateTask ({required String id, required String name, required String description, required Timestamp dueDate, required bool isCompleted, required String priority, }) {
    return UpdateTaskVariablesBuilder(dataConnect, id: id,name: name,description: description,dueDate: dueDate,isCompleted: isCompleted,priority: priority,);
  }
  
  
  DeleteTaskVariablesBuilder deleteTask ({required String id, }) {
    return DeleteTaskVariablesBuilder(dataConnect, id: id,);
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
