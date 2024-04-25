import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String? uid;
  String? accountId;
  String? accountName;
  String? accountType;
  String? accountTotal;
  String? currency;
  String? auto;
  String? transfer;
  String? toAccountId;
  String? transferDate;

  TransactionModel(
      {this.uid, this.accountId, this.accountName, this.accountType, this.accountTotal, this.currency, this.auto, this.transfer, this.toAccountId,this.transferDate});

  // receiving data from server
  factory TransactionModel.fromMap(map) {
    return TransactionModel(
      uid: map['uid'],
      accountId: map['accountId'],
      accountName: map['accountName'],
      accountType: map['accountType'],
      accountTotal: map['accountTotal'],
      currency: map['currency'],
      auto: map['auto'],
      transfer: map['transfer'],
      toAccountId: map['toAccountId'],
      transferDate: map['transferDate'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'currency': currency,
      'accountId': accountId,
      'accountName': accountName,
      'accountType': accountType,
      'accountTotal': accountTotal,
      'auto': auto,
      'transfer': transfer,
      'toAccountId': toAccountId,
      'transferDate': transferDate,
    };
  }

  // adding transaction List
  Map<String, dynamic> transaction(String transactionDate, String transactionId, String transactionType, String transactionAmount, String untagged,
      String categoryName,String categoryLogo, String categoryBgColor, String createdDate, String lastUpdatedDate) {
    return {
      'transaction': FieldValue.arrayUnion([
        {
          'transactionDate': transactionDate,
          'transactionId': transactionId,
          'transactionType':transactionType,
          'transactionAmount': transactionAmount,
          'untagged': untagged,
          'categoryName': categoryName,
          'categoryLogo': categoryLogo,
          'categoryBgColor': categoryBgColor,
          'createdDate': createdDate,
          'lastUpdatedDate': lastUpdatedDate,
        }
      ])
    };
  }
}
