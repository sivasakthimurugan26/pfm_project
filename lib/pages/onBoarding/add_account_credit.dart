import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

import 'add_account_name.dart';

class AddCreditAccount extends StatefulWidget {
  final bool fromAccountPage;
  const AddCreditAccount({Key? key, required this.fromAccountPage}) : super(key: key);

  @override
  _AddCreditAccountState createState() => _AddCreditAccountState();
}

class _AddCreditAccountState extends State<AddCreditAccount> {
  bool isFirst = true;

  final FocusNode creditFocus = FocusNode();
  TextEditingController creditAmountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          // FocusScope.of(context).unfocus();
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffFFE4ED), Color(0xffffffff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/accountCredit.png', width: 40),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  child: Text(
                                    'Credit',
                                    style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        const Text(
                          'What\'s the Credit Card',
                          style: TextStyle(fontSize: 25, fontFamily: 'Gilroy Medium'),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        const Text(
                          'Enter your credit card balance',
                          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '\u{20B9} ',
                          style: TextStyle(color: Color(0xff727272), fontSize: 25),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: creditAmountTextController,
                            focusNode: creditFocus,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              String newValue = value.replaceAll(',', '').replaceAll('.', '');
                              if (value.isEmpty || newValue == '00') {
                                creditAmountTextController.clear();
                                isFirst = true;
                                return;
                              }
                              double value1 = double.parse(newValue);
                              if (!isFirst) value1 = value1 * 100;
                              value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                              creditAmountTextController.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(offset: value.length),
                              );
                            },
                            style: const TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold'),
                            decoration: const InputDecoration(
                              hintText: "0.00 ",
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          child: SvgPicture.asset('assets/svg/edit_button.svg'),
                          onTap: () {
                            creditFocus.requestFocus();
                          },
                        ),
                      ],
                    ),

                    // Text('0.00', style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 45),),
                    SizedBox(
                      height: height * 0.23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: width * 0.40,
                            decoration: const BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                  child: Text(
                                'Back',
                                style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                              )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (creditAmountTextController.text.isEmpty) {
                              snackBarWidget("Help us here", "Please update the balance.");
                              creditFocus.requestFocus();
                            } else {
                              Get.to(() => AddAccountName(fromAccountPage:widget.fromAccountPage), arguments: [
                                '0xffFFE4ED',
                                'Credit',
                                creditAmountTextController.text,
                                'assets/images/accountCredit.png',
                              ]);
                            }
                          },
                          child: Container(
                            width: width * 0.40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// addAccount() async{
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   User? user = FirebaseAuth.instance.currentUser;
//
//   AccountModel accountModel = AccountModel();
//
//   accountModel.uid = user?.uid;
//   accountModel.accountId =
//
// }
}
