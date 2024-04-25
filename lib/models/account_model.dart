class AccountModel {
  String? accountId;
  String? accountName;
  String? accountType;
  String? currency;
  String? amountBalance;
  String? isAvailable;

  AccountModel({ this.accountId, this.accountName, this.accountType, this.currency, this.amountBalance, this.isAvailable});

  // receiving data from server
  factory AccountModel.fromMap(map) {
    return AccountModel(
        accountId: map['accountId'],
        accountName: map['accountName'],
        accountType: map['accountType'],
        currency: map['currency'],
        amountBalance: map['amountBalance'],
        isAvailable: map['isAvailable']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'accountName': accountName,
      'accountType': accountType,
      'currency': currency,
      'amountBalance': amountBalance,
      'isAvailable': isAvailable
    };
  }
}
