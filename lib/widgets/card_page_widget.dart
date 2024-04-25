import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../pages/transactions/all_transaction.dart';



class CardPage extends StatelessWidget {
  final Map _cardDetails;
  int counter;
  CardPage(this._cardDetails, this.counter, {Key? key}) : super(key: key);

  Color topColor = const Color(0xffffffff);
  Color bottomColor = const Color(0xffffffff);
  String accountTypeIcon = ' ';

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    // print("cardDetails: ${_cardDetails}");

    if (_cardDetails['accountType'] == 'Savings') {
      bottomColor = const Color(0xff7EE8FF);
      topColor = const Color(0xffD6F8FF);
      accountTypeIcon='assets/images/accountSavings.png';
    } else if (_cardDetails['accountType'] == 'Credit Card') {
      bottomColor = const Color(0xffFF84AB);
      topColor = const Color(0xffFFDFE9);
      accountTypeIcon='assets/images/accountCredit.png';
    } else if (_cardDetails['accountType'] == 'Cash') {
      bottomColor = const Color(0xff88FFC7);
      topColor = const Color(0xffE2FFF2);
      accountTypeIcon='assets/images/accountCash.png';
    }

    // print('cardDetails: $_cardDetails');
    var formatter = NumberFormat.currency(locale: "en_US", symbol: "\u{20B9}");
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [topColor, bottomColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        // color: Colors.brown,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _cardDetails['accountName'],
                        style: textTheme.titleMedium,
                      ),
                      // style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18, color: Colors.black)),
                      Row(
                        children: [
                          Image.asset(
                            accountTypeIcon,
                            width:40,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Text(_cardDetails['accountType'],
                                    style: textTheme.titleSmall),
                                //style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: Color(0xff3a3a3a))),
                              )),
                        ],
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Text('\u{20B9}',
                          style: textTheme.titleLarge,
                          // style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 25, color: Color(0xff3a3a3a)),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        // child: Text(formatter.format(_cardDetails['amountBalance']),style: textTheme.titleLarge,
                        child: Text(_cardDetails['accountTotal'],
                            style: textTheme.titleLarge,
                            // style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 25, color: Color(0xff3a3a3a)),
                            overflow: TextOverflow.ellipsis),
                      ),
                      GestureDetector(
                        onTap: (){
                          // var accountTitle='Untagged';
                          Get.to(() =>  NewAllTransaction(counter,accountTitle:'Untagged'));
                        },
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffFF6349),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text('$counter Untagged', style:textTheme.titleSmall,),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
