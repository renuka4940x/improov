import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:improov/src/data/models/app_settings/app_settings.dart';
import 'package:improov/src/data/models/habit/habit.dart';
import 'package:improov/src/data/models/task/task.dart';
import 'package:isar/isar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin 
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel habitChannel = 
  AndroidNotificationChannel(
    'habit_reminders_id',
    'Habit Reminders',
    description: 'Notifications for daily habit tracking and streaks.', 
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  static const AndroidNotificationChannel taskChannel = 
  AndroidNotificationChannel(
    'task_reminders_id',
    'Task Reminders',
    description: 'Notifications for Task reminders.', 
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  Future<void> initNotification() async {
    // initializing timezone
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    //CREATE THE CHANNEL
    await _notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(habitChannel);
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          habitChannel.id,
          habitChannel.name, 
          channelDescription: habitChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleHabitReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // TimeZone-aware DateTime
    final now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year, now.month, now.day, 
      scheduledTime.hour, scheduledTime.minute
    );

    // If the time already passed today, schedule for tomorrow
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: id, 
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          habitChannel.id,
          habitChannel.name,
          channelDescription: habitChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Removes recurring notification for deleted habit
  Future<void> cancelHabitNotifications(int habitId) async {
    for (int i = 0; i < 7; i++) {
      final notificationId = (habitId * 100000) + i; 
      
      await _notificationsPlugin.cancel(id: notificationId); 
    }
    
    debugPrint("🛑 Canceled all recurring notifications for Habit ID: $habitId");
  }

  // Removes a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    debugPrint("🛑 Canceled single notification ID: $id");
  }

  //HABIT WATCHER
  void listenToHabitChanges(Isar isar) {
    debugPrint(" Habit Notification Watcher Started...");

    isar.habits.watchLazy().listen((_) async {
      debugPrint("Watcher triggered! Database changed. Scanning habits...");
      final habits = await isar.habits.where().findAll();

      final settings = await isar.appSettings.get(0);
      final globalNotificationsOn = settings?.notifyHabitReminders ?? true;
      final isPremium = settings?.subscriptionType == SubscriptionType.monthly || 
        settings?.subscriptionType == SubscriptionType.yearly;

      for (var habit in habits) {
        final completionsThisWeek = _getCompletionsForCurrentWeek(habit.completedDays);
        final goalMet = completionsThisWeek >= habit.goalDaysPerWeek;

        debugPrint("[${habit.name}] -> GlobalOn: $globalNotificationsOn | Time: ${habit.reminderTime} | GoalMet: $goalMet (${habit.goalDaysPerWeek} days)");

        if (globalNotificationsOn && !goalMet) {
          
          DateTime timeToRing;
          
          // THE ROUTER
          if (isPremium && habit.reminderTime != null) {
            timeToRing = habit.reminderTime!;
            debugPrint("Yoo! Here's your reminder for ${habit.name} at exact time: $timeToRing, get it done mate!!");
          } else {
            // FREE
            final now = DateTime.now();
            timeToRing = DateTime(now.year, now.month, now.day, 9, 0);
            debugPrint("Daily reminder for ${habit.name} is here~");
          }

          await scheduleHabitReminder(
            id: habit.id, 
            title: "Time for ${habit.name}!",
            body: "You're at $completionsThisWeek/${habit.goalDaysPerWeek} this week. Let's get it done!",
            scheduledTime: timeToRing,
          );
          
        } else {
          // Goal met or global notifications off
          debugPrint("Canceling alarm for ${habit.name}");
          await cancelNotification(habit.id);
        }
      }
    });
  }

  int _getCompletionsForCurrentWeek(List<DateTime> completedDays) {
    if (completedDays.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));    
    final endOfWeekCutoff = startOfWeek.add(const Duration(days: 7));

    return completedDays.where((date) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      // Is it >= Monday AND < Next Monday?
      return (
        normalizedDate.isAtSameMomentAs(startOfWeek) 
        || normalizedDate.isAfter(startOfWeek)
      ) && normalizedDate.isBefore(endOfWeekCutoff);
    }).length;
  }

  //TASK SCHEDULER
  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year, now.month, now.day, 
      scheduledTime.hour, scheduledTime.minute
    );

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: id, 
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          taskChannel.id, 
          taskChannel.name,
          channelDescription: taskChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // TASK WATCHER
  void listenToTaskChanges(Isar isar) {
    debugPrint("Task Notification Watcher Started...");

    _syncAllTasks(isar);

    isar.tasks.watchLazy().listen((_) async {
      debugPrint("Watcher triggered! Database changed. Scanning tasks...");
      _syncAllTasks(isar);
    });
  }

  Future<void> _syncAllTasks(Isar isar) async {
    final settings = await isar.appSettings.get(0);
    final globalNotificationsOn = settings?.notifyTaskDeadlines ?? true; 
    final isPremium = settings?.subscriptionType == SubscriptionType.monthly || 
      settings?.subscriptionType == SubscriptionType.yearly;

    final tasks = await isar.tasks.where().findAll();

    for (var task in tasks) {
      final notificationId = task.id + 100000;

      if (!globalNotificationsOn || task.isCompleted) {
        await cancelNotification(notificationId);
        continue;
      }

      DateTime? timeToRing;

      if (isPremium && task.reminderTime != null) {
        timeToRing = task.reminderTime!;
      } else if (task.dueDate != null) {
        timeToRing = DateTime(
          task.dueDate!.year, 
          task.dueDate!.month, 
          task.dueDate!.day, 
          9, 0
        );
      }

      if (timeToRing != null && timeToRing.isAfter(DateTime.now())) {
        debugPrint("Scheduling Task [${task.title}] for $timeToRing");

        await scheduleTaskReminder( 
          id: notificationId,
          title: "Task Due: ${task.title}",
          body: "Don't forget to crush this today!",
          scheduledTime: timeToRing,
        );

      } else {
      await cancelNotification(notificationId);
      }
    }
  }
}

