import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    final id = inputData?['id'] as int;
    final title = inputData?['title'] as String?;
    final body = inputData?['body'] as String?;
    final payload = inputData?['payload'] as String?;
    final reminderType = inputData?['reminderType'] as String?;
    final reminderData = inputData?['reminderData'] as Map<String, dynamic>;
    final scheduledDateTime = inputData?['scheduledDateTime'] as String;

    final NotificationService notificationService = NotificationService();

    switch (reminderType) {
      case 'Daily':
        notificationService.scheduleRecurringNotification(
          id: id,
          title: title!,
          body: body!,
          payload: payload!,
          scheduledDateTime: DateTime.parse(scheduledDateTime),
          reminderType: reminderType!,
        );
        break;
      case 'Weekly':
        notificationService.scheduleWeeklyNotification(
          id: id,
          title: title!,
          body: body!,
          payload: payload!,
          dayOfWeek: reminderData['dayOfWeek'] as String,
          scheduledTime: DateTime.parse(scheduledDateTime),
          reminderType: reminderType!,
        );
        break;
      case 'Monthly':
        notificationService.scheduleMonthlyNotification(
          id: id,
          title: title!,
          body: body!,
          payload: payload!,
          dayOfMonth: reminderData['dayOfMonth'] as int,
          scheduledTime: DateTime.parse(scheduledDateTime),
          reminderType: reminderType!,
        );
        break;
      case 'Yearly':
        notificationService.scheduleYearlyNotification(
          id: id,
          title: title!,
          body: body!,
          payload: payload!,
          monthOfYear: reminderData['monthOfYear'] as int,
          dayOfMonth: reminderData['dayOfMonth'] as int,
          scheduledTime: DateTime.parse(scheduledDateTime),
          reminderType: reminderType!,
        );
        break;
      default:
      // Handle unsupported reminder type
    }

    return Future.value(true);
  });
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  initNotification() async {
    AndroidInitializationSettings initAndroidSettings = const AndroidInitializationSettings('pfm_logo');

    var initIOSSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

    var initNotifySettings = InitializationSettings(android: initAndroidSettings, iOS: initIOSSettings);

    await notificationsPlugin.initialize(initNotifySettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  AndroidNotificationDetails androidNotificationDetails() {
    return const AndroidNotificationDetails(
      'Channel_id',
      'Channel_title',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'pfm_logo',
      channelShowBadge: true,
      styleInformation: BigTextStyleInformation(''),
      largeIcon: DrawableResourceAndroidBitmap('pfm_logo'),
    );
  }

  NotificationDetails notificationDetails() {
    final androidDetails = androidNotificationDetails();
    return NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails());
  }

  showNotification(int id, String? title, String? body, String? payload) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDateTime,
    required String reminderType,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    print('scheduledDateTime: $scheduledDateTime');
    print('scheduledDateTime1: ${tz.TZDateTime.from(scheduledDateTime, tz.local)}');

    if (scheduledDateTime.isAfter(now) || scheduledDateTime.isAtSameMomentAs(now)) {
      print('came Here');
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      // The scheduled time has already passed; schedule it for the next recurrence
      tz.TZDateTime nextOccurrence = tz.TZDateTime(
          tz.local, scheduledDateTime.year, scheduledDateTime.month, scheduledDateTime.day, scheduledDateTime.hour, scheduledDateTime.minute);

      while (nextOccurrence.isBefore(now) || nextOccurrence.isAtSameMomentAs(now)) {
        nextOccurrence = nextOccurrence.add(const Duration(days: 1));
      }

      print('nextOccurrence: $nextOccurrence');

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        nextOccurrence,
        notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      Workmanager().registerOneOffTask(
        'scheduleNotification',
        'scheduleNotification',
        inputData: <String, dynamic>{
          'id': id + 1,
          'title': title,
          'body': body,
          'payload': payload,
          'scheduledDateTime': scheduledDateTime.add(const Duration(days: 1)).toIso8601String(),
          'reminderType': reminderType,
          'reminderData': {},
        },
        initialDelay: const Duration(seconds: 1),
      );
    }
  }

  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String dayOfWeek, // e.g., "Monday", "Tuesday", ...
    required DateTime scheduledTime,
    required String reminderType,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Calculate the next occurrence date for the specified day of the week and time
    tz.TZDateTime nextOccurrence = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // Find the next occurrence by comparing with the specified day of the week
    while (nextOccurrence.isBefore(now) || nextOccurrence.isAtSameMomentAs(now) || nextOccurrence.weekday != _getDayOfWeekNumber(dayOfWeek)) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextOccurrence,
      notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Schedule the next weekly notification
    Workmanager().registerOneOffTask(
      'scheduleNotification',
      'scheduleNotification',
      inputData: <String, dynamic>{
        'id': id + 1,
        'title': title,
        'body': body,
        'payload': 'next_notification_payload',
        'scheduledDateTime': nextOccurrence.toIso8601String(),
        'reminderType': reminderType,
        'reminderData': {
          'dayOfWeek': dayOfWeek,
        },
      },
      initialDelay: const Duration(seconds: 1),
    );
  }

  int _getDayOfWeekNumber(String dayOfWeek) {
    switch (dayOfWeek) {
      case 'Mon':
        return DateTime.monday;
      case 'Tue':
        return DateTime.tuesday;
      case 'Wed':
        return DateTime.wednesday;
      case 'Thu':
        return DateTime.thursday;
      case 'Fri':
        return DateTime.friday;
      case 'Sat':
        return DateTime.saturday;
      case 'Sun':
        return DateTime.sunday;
      default:
        throw Exception('Invalid day of the week: $dayOfWeek');
    }
  }

  Future<void> scheduleMonthlyNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int dayOfMonth, // e.g., 1, 15, ...
    required DateTime scheduledTime,
    required String reminderType,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Calculate the next occurrence date for the specified day of the month and time
    tz.TZDateTime nextOccurrence = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      dayOfMonth,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    while (nextOccurrence.isBefore(now) || nextOccurrence.isAtSameMomentAs(now)) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 30)); // Assuming 30 days per month
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextOccurrence,
      notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Convert your reminderData map to a JSON string
    String reminderDataJson = jsonEncode({
      'dayOfMonth': dayOfMonth,
    });

    Workmanager().registerOneOffTask(
      'scheduleNotification',
      'scheduleNotification',
      inputData: <String, dynamic>{
        'id': id + 1,
        'title': title,
        'body': body,
        'payload': 'next_notification_payload',
        'scheduledDateTime': nextOccurrence.toIso8601String(),
        'reminderType': reminderType,
        'reminderData': reminderDataJson
      },
      initialDelay: const Duration(seconds: 1),
    );
  }

  Future<void> scheduleYearlyNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required int monthOfYear, // e.g., 1 (January), 6 (June), ...
    required int dayOfMonth, // e.g., 1, 15, ...
    required DateTime scheduledTime,
    required String reminderType,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Calculate the next occurrence date for the specified month, day, and time
    tz.TZDateTime nextOccurrence = tz.TZDateTime(
      tz.local,
      now.year,
      monthOfYear,
      dayOfMonth,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    if (nextOccurrence.isBefore(now) || nextOccurrence.isAtSameMomentAs(now)) {
      nextOccurrence = nextOccurrence.add(const Duration(days: 365)); // Assuming 365 days per year
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextOccurrence,
      notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    Workmanager().registerOneOffTask(
      'scheduleNotification',
      'scheduleNotification',
      inputData: <String, dynamic>{
        'id': id + 1,
        'title': title,
        'body': body,
        'payload': 'next_notification_payload',
        'scheduledDateTime': nextOccurrence.toIso8601String(),
        'reminderType': reminderType,
        'reminderData': {
          'monthOfYear': monthOfYear,
          'dayOfMonth': dayOfMonth,
        },
      },
      initialDelay: const Duration(seconds: 1),
    );
  }

  // Future<void> scheduleNotification(String reminderType, Map<String, dynamic> reminderData) async {
  //   final NotificationDetails details = notificationDetails();
  //   final now = tz.TZDateTime.now(tz.local);
  //
  //   switch (reminderType) {
  //     case 'Yearly':
  //       final reminderMonth = reminderData['reminderMonth'];
  //       final reminderDate = reminderData['reminderDate'];
  //       final reminderTime = reminderData['reminderTime'];
  //
  //       final parsedMonth = DateFormat.MMM().parse(reminderMonth);
  //       final monthEnumValue = parsedMonth.month;
  //
  //       final scheduledDate = tz.TZDateTime(tz.local, now.year, monthEnumValue, reminderDate, 9, 0);
  //
  //       if (scheduledDate.isBefore(now)) {
  //         scheduledDate.add(const Duration(days: 365)); // Schedule for next year if the date has already passed
  //       }
  //
  //       await notificationsPlugin.zonedSchedule(
  //         0, // Replace with a unique notification ID
  //         'Yearly Reminder', // Replace with your notification title
  //         'Yearly reminder message', // Replace with your notification message
  //         scheduledDate,
  //         details,
  //         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //       break;
  //
  //     case 'Daily':
  //       final reminderTime = reminderData['reminderTime'];
  //       final timeParts = reminderTime.split(' ')[0].split(':');
  //       var hour = int.parse(timeParts[0]);
  //       final minute = int.parse(timeParts[1]);
  //       final isPM = reminderTime.contains('PM');
  //
  //       if (isPM && hour < 12) {
  //         hour += 12;
  //       } else if (!isPM && hour == 12) {
  //         hour = 0;
  //       }
  //
  //       final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  //
  //       if (scheduledDate.isBefore(now)) {
  //         scheduledDate.add(const Duration(days: 1)); // Schedule for the next day if the time has already passed
  //       }
  //
  //       await notificationsPlugin.zonedSchedule(
  //         0, // Replace with a unique notification ID
  //         'Daily Reminder', // Replace with your notification title
  //         'Daily reminder message', // Replace with your notification message
  //         scheduledDate,
  //         details,
  //         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //       break;
  //
  //     case 'Weekly':
  //       final reminderTime = reminderData['reminderTime'];
  //       final reminderDay = reminderData['reminderDay'];
  //
  //       final timeParts = reminderTime.split(':');
  //       final hour = int.parse(timeParts[0]);
  //       final minute = int.parse(timeParts[1]);
  //
  //       final weekday = tz.TZDateTime.now(tz.local).weekday;
  //       final daysUntilNextWeekday = (DateTime.daysPerWeek + DateTime.parse(reminderDay).weekday - weekday) % DateTime.daysPerWeek;
  //
  //       final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day + daysUntilNextWeekday, hour, minute);
  //
  //       if (scheduledDate.isBefore(now)) {
  //         scheduledDate.add(const Duration(days: 7)); // Schedule for the next week if the time has already passed
  //       }
  //
  //       await notificationsPlugin.zonedSchedule(
  //         0, // Replace with a unique notification ID
  //         'Weekly Reminder', // Replace with your notification title
  //         'Weekly reminder message', // Replace with your notification message
  //         scheduledDate,
  //         details,
  //         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //       break;
  //
  //     case 'Monthly':
  //       final reminderMonthDate = reminderData['reminderMonthDate'];
  //       final reminderTime = reminderData['reminderTime'];
  //       final timeParts = reminderTime.split(':');
  //       final hour = int.parse(timeParts[0]);
  //       final minute = int.parse(timeParts[1]);
  //
  //       final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, reminderMonthDate, hour, minute);
  //
  //       if (scheduledDate.isBefore(now)) {
  //         scheduledDate.add(const Duration(days: 30)); // Schedule for the next month if the time has already passed
  //       }
  //
  //       await notificationsPlugin.zonedSchedule(
  //         0, // Replace with a unique notification ID
  //         'Monthly Reminder', // Replace with your notification title
  //         'Monthly reminder message', // Replace with your notification message
  //         scheduledDate,
  //         details,
  //         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //       break;
  //
  //     default:
  //       break;
  //   }
  // }
}
