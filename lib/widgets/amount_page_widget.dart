import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_management/constants/color.dart';

import 'edit_popup/transaction_popup_box.dart';

class AmountPage extends StatelessWidget {
  final Map _amount;
  final ScrollController controller;

  AmountPage(this._amount, this.controller);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');
    return
      ListView.builder(
        controller: controller,
        itemCount: (_amount['transaction'] as List).length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[],
            );
          }
          var transactions = _amount['transaction'][i - 1];
          DateTime dateTime = dateFormat.parse(transactions['lastUpdatedDate']);
          var transactionDate = DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);

          return GestureDetector(
            onLongPress: (){
              showGeneralDialog(
                barrierDismissible: true,
                barrierLabel: '',
                barrierColor: Colors.black38,
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (ctx, anim1, anim2) => TransactionPopUpBox(transactionData: _amount,index: i-1,),
                // pageBuilder: (ctx, anim1, anim2) => SecondPopUpDashboard(budget: categoriesList['budgetedAmount'], available: categoriesList['availableAmount'], icon: categoriesList['categoryLogo'], categoryName: categoriesList['categoryName'], backgroundColor: categoriesList['backgroundColor'],),
                // pageBuilder: (ctx, anim1, anim2) => SecondPopUpDashboard(data: [categoriesList],),
                transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                  child: FadeTransition(
                    child: child,
                    opacity: anim1,
                  ),
                ),
                context: context,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(int.parse(transactions['categoryBgColor'])),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            transactions['categoryLogo'],
                            width: 70,
                          )),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.17,
                        bottom: MediaQuery.of(context).size.height * 0.007,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transactions['categoryName'],
                                style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 20),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                child: Text(
                                  transactionDate,
                                  style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: transAmount),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width * 0.025,
                        bottom: MediaQuery.of(context).size.height * 0.025,
                        child: Text(
                          '\u{20B9} ${transactions['transactionAmount']}',
                          style: TextStyle(
                              color: transactions['transactionType'] == 'Credit' ? rupeeCredit : transAmountDebit,
                              fontFamily: "Gilroy Bold",
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
  }
}