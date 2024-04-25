class BudgetModel {
  String? uid;
  String? month;
  String? currency;
  String? allocatedAmount;
  String? availableAmount;

  BudgetModel({this.uid, this.currency, this.allocatedAmount, this.availableAmount});

  // receiving data from server
  factory BudgetModel.fromMap(map) {
    return BudgetModel(
        uid: map['uid'],
        currency: map['currency'],
        allocatedAmount: map['amountBalance'],
        availableAmount: map['isAvailable']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'currency': currency,
      'allocatedAmount': allocatedAmount,
      'availableAmount': availableAmount
    };
  }
}
