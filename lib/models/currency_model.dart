class CurrencyModel {
  String? code;
  String? description;
  String? symbol;
  String? decimalsAllowed;
  String? createDateTime;
  String? lastUpdateDateTime;

  CurrencyModel({this.code, this.description, this.symbol, this.decimalsAllowed,this.createDateTime, this.lastUpdateDateTime,});

  // receiving data from server
  factory CurrencyModel.fromMap(map) {
    return CurrencyModel(
        code: map['uid'],
        description: map['categoryName'],
        symbol: map['categoryLogo'],
        decimalsAllowed:map['categoryLogoColor'],
        createDateTime: map['availableCurrency'],
        lastUpdateDateTime: map['availableAmount']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': code,
      'categoryName': description,
      'categoryLogo': symbol,
      'categoryLogoColor':decimalsAllowed,
      'availableCurrency': createDateTime,
      'availableAmount': lastUpdateDateTime,
    };
  }
}
