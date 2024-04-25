import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:personal_finance_management/widgets/emptyMessageWidget.dart';

class NewMyListView extends StatefulWidget {
  const NewMyListView({
    Key? key,
  }) : super(key: key);

  @override
  State<NewMyListView> createState() => _NewMyListViewState();
}

class _NewMyListViewState extends State<NewMyListView> {
  bool visibleMenu = false;
  String updateValue = '';

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  final firestoreInstance = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getInformation() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    return firestoreInstance.collection("UserData").doc(firebaseUser?.uid).get();
  }

  stringToDate(String data) {
    var dayy = data.substring(8, 10);
    var month = data.substring(5, 7);
    var year = data.substring(0, 4);
    final intDay = int.parse(dayy);
    final intMonth = int.parse(month);
    final intYear = int.parse(year);
    final formattedDate = DateTime.utc(intYear, intMonth, intDay);
    // print("formattedDate:${formattedDate}");
    return formattedDate;
  }

  @override
  void initState() {
    visibleMenu = true;
    getInformation();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('UserData').doc(firebaseUser?.uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final DocumentSnapshot? document = snapshot.data;
        final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

        if (snapshot == null) {
          return const CircularProgressIndicator();
        }

        return documentData['remainder'] != null
            ? Container(
                color: const Color(0xffFFFFFF),
                width: MediaQuery.of(context).size.width * 4.0,
                height: MediaQuery.of(context).size.height,
                child: GroupedListView<dynamic, String>(
                  elements: documentData['remainder'],
                  groupBy: (element) => element['remainderCreatedDate'],
                  order: GroupedListOrder.ASC,
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  groupSeparatorBuilder: (String val) {
                    if (val.compareTo(DateFormat('yyyy/MM/dd').format(DateTime.now()).toString()) == 0) {
                      val = 'Today\'s Activities';
                    } else {
                      val = DateFormat("dd/MM/yyyy").format(stringToDate(val));
                    }

                    return Container(
                      padding: const EdgeInsets.only(left: 35, bottom: 10, top: 10),
                      child: Text(
                        val,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Gilroy Medium',
                        ),
                      ),
                    );
                  },
                  itemBuilder: (c, element) {
                    var remainderName = element['eventInfo']['remainderName'];
                    var remainderColor = element['eventInfo']['remainderColor'];
                    var remainderDesc = element['eventInfo']['remainderDesc'];
                    var remainderIcon = element['eventInfo']['remainderIcon'];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff403f3f).withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(15, 15),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Container(
                                height: 80,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      color: Color(int.parse(remainderColor)),
                                      // color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          remainderName,
                                          style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Color(0xff181818)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          remainderDesc,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Gilroy Medium',
                                            color: Color(0xffCACACA),
                                          ),
                                        ),
                                      ],
                                    )),
                                    Image.asset(
                                      remainderIcon,
                                      width: 35,
                                      height: 35,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            : EmptyMessageWidget(isAllTransaction: false, text: 'Reminder');
      },
    );
  }
}
