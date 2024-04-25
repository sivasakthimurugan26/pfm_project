import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? mobile;
  String? profileImage;
  String? profileColor;
  List? accountsData;
  List? budgetData;
  List? categoryData;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.mobile,
    this.profileImage,
    this.profileColor,
  });

  // Add data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'profileImage': profileImage,
      'profileColor': profileColor,
    };
  }

  // adding accounts List
  Map<String, dynamic> accounts(String accountId, String accountName, String accountType, String currency, String amountBalance, String isAvailable) {
    return {
      'accounts': FieldValue.arrayUnion([
        {
          'accountId': accountId,
          'accountName': accountName,
          'accountType': accountType,
          'currency': currency,
          'amountBalance': amountBalance,
          'isAvailable': isAvailable
        }
      ])
    };
  }

  // adding budget
  Map<String, dynamic> budget(String month, String currency, String allocatedAmount, String availableAmount) {
    return {
      'budget': {'month': month, 'currency': currency, 'allocatedAmount': allocatedAmount, 'availableAmount': availableAmount}
    };
  }

  // adding category List
  Map<String, dynamic> categories(String categoryId, String categoryName, String categoryLogo, String backgroundColor, String availableCur,
      String availableAmount, String budgetedCur, String budgetedAmount, String spentAmount) {
    return {
      'categories': FieldValue.arrayUnion([
        {
          'categoryId': categoryId,
          'categoryName': categoryName,
          'categoryLogo': categoryLogo,
          'backgroundColor': backgroundColor,
          'availableCur': availableCur,
          'availableAmount': availableAmount,
          'budgetedCur': budgetedCur,
          'budgetedAmount': budgetedAmount,
          'spentAmount': spentAmount
        }
      ])
    };
  }

  //add notification
  Map<String, dynamic> notification(String title, String type, DateTime notifyDate) {
    return {
      'notification': FieldValue.arrayUnion([
        {
          'notifyTitle': title,
          'notifyType': type,
          'notifyDate': notifyDate,
        }
      ])
    };
  }
}

//Reminder
class Remainder {
  Remainder({
    this.remainderCreatedDate,
    this.remainderEventType,
    this.eventInfo,
    this.remainderDataInfo,
  });
  String? remainderCreatedDate;
  String? remainderEventType;
  EventInfo? eventInfo;
  RemainderDataInfo? remainderDataInfo;

  factory Remainder.fromMap(Map<String, dynamic> json) {
    return Remainder(
      remainderCreatedDate: json["remainderCreatedDate"],
      remainderEventType: json["remainderEventType"],
      eventInfo: EventInfo.fromMap(json["eventInfo"]),
      remainderDataInfo: RemainderDataInfo.fromMap(json["remainderDataInfo"]),
    );
  }
  Map<String, dynamic> toMap(remainderCreatedDate, remainderEventType, eventInfo, remainderDataInfo) {
    return {
      'remainder': FieldValue.arrayUnion([
        {
          "remainderCreatedDate": remainderCreatedDate,
          "remainderEventType": remainderEventType,
          "eventInfo": eventInfo,
          "remainderDataInfo": remainderDataInfo,
        }
      ])
    };
  }
}

class EventInfo {
  EventInfo({
    this.eventDate,
    this.events,
  });
  String? eventDate;
  Events? events;
  factory EventInfo.fromMap(Map<String, dynamic> json) {
    return EventInfo(
      eventDate: json["eventDate"],
      events: Events.fromMap(json["events"]),
    );
  }
  Map<String, dynamic> toMap(eventDate, events) {
    return {
      'eventInfo': FieldValue.arrayUnion([
        {
          "eventDate": eventDate,
          "events": events,
        }
      ])
    };
  }
}

class Events {
  Events({
    this.remainderId,
    this.remainderName,
    this.remainderDesc,
    this.remainderIcons,
    this.remainderColor,
    this.remainderCategory,
  });
  String? remainderId;
  String? remainderName;
  String? remainderDesc;
  String? remainderIcons;
  String? remainderColor;
  String? remainderCategory;
  factory Events.fromMap(Map<String, dynamic> json) {
    return Events(
      remainderId: json["remainderId"],
      remainderName: json["remainderName"],
      remainderDesc: json["remainderDesc"],
      remainderIcons: json["remainderIcons"],
      remainderColor: json["remainderColor"],
      remainderCategory: json["remainderCategory"],
    );
  }
  Map<String, dynamic> toMap(
    remainderId,
    remainderName,
    remainderDesc,
    remainderIcons,
    remainderColor,
    remainderCategory,
  ) {
    return {
      'events': FieldValue.arrayUnion([
        {
          "remainderId": remainderId,
          "remainderName": remainderName,
          "remainderDesc": remainderDesc,
          "remainderIcons": remainderIcons,
          "remainderColor": remainderColor,
          "remainderCategory": remainderCategory,
        }
      ])
    };
  }
}

class RemainderDataInfo {
  RemainderDataInfo({
    this.remainderType,
    this.typeInfo,
  });
  String? remainderType;
  TypeInfo? typeInfo;
  factory RemainderDataInfo.fromMap(Map<String, dynamic> json) {
    return RemainderDataInfo(
      remainderType: json["remainderType"],
      typeInfo: TypeInfo.fromMap(json["typeInfo"]),
    );
  }
  Map<String, dynamic> toMap(
    remainderType,
    typeInfo,
  ) {
    return {
      'remainderDataInfo': FieldValue.arrayUnion([
        {
          "remainderType": remainderType,
          "typeInfo": typeInfo,
        }
      ])
    };
  }
}

class TypeInfo {
  TypeInfo({
    this.hours,
    this.minutes,
    this.timeFormat,
    this.day,
    this.month,
  });
  String? hours;
  String? minutes;
  String? timeFormat;
  String? day;
  String? month;
  factory TypeInfo.fromMap(Map<String, dynamic> json) {
    return TypeInfo(
      hours: json["hours"],
      minutes: json["minutes"],
      timeFormat: json["timeFormat"],
      day: json["day"],
      month: json["month"],
    );
  }
  Map<String, dynamic> toMap(
    hours,
    minutes,
    timeFormat,
    day,
    month,
  ) {
    return {
      'typeInfo': FieldValue.arrayUnion([
        {
          "hours": hours,
          "minutes": minutes,
          "timeFormat": timeFormat,
          "day": day,
          "month": month,
        }
      ])
    };
  }
}
