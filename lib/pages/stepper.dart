import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account.dart';
import 'package:personal_finance_management/pages/onBoarding/add_budget.dart';
import 'package:personal_finance_management/pages/onBoarding/add_category.dart';

class StepperPage extends StatefulWidget {
  String visited;
  int activeIndex;

  StepperPage(this.visited, this.activeIndex, {Key? key}) : super(key: key);

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  bool createAccount = true;
  bool budgetCreated = false;
  bool categoryCreated = false;

  bool step1 = false;
  bool step2 = false;
  bool finished = false;
  bool step3 = false;

  @override
  void initState() {
    super.initState();
    if (widget.visited == 'budgetVisited') {
      step1 = true;
      createAccount = false;
      budgetCreated = true;
      categoryCreated = false;
    }
    if (widget.visited == 'categoryVisited') {
      step1 = true;
      step2 = true;
      createAccount = false;
      budgetCreated = false;
      categoryCreated = true;
    }
    if (widget.visited == 'dashboard') {
      step1 = true;
      step2 = true;
      step3 = true;
      createAccount = false;
      budgetCreated = false;
      categoryCreated = false;
    }
    if (widget.activeIndex == 4) {
      step1 = true;
      step2 = true;
      step3 = true;
      finished = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = [
      StepperData(
          title: StepperText(
            "Start",
            textStyle: const TextStyle(
              fontSize: 18,
              fontFamily: 'Gilroy Medium',
            ),
          ),
          iconWidget: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color(0xff85E1B5), //(0xffFF9D34)
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: SvgPicture.asset(
                'assets/images/tick.svg',
                color: Colors.black,
              ),
            ),
          )),
      StepperData(
          title: StepperText(
            "Step 1",
            textStyle: const TextStyle(
              // color: step1?Colors.black:Colors.grey,
              fontSize: 16, fontFamily: 'Gilroy Light',
            ),
          ),
          subtitle: StepperText(
            "Create Account",
            textStyle: const TextStyle(
              // color: step1?Colors.black:Colors.grey,
              fontSize: 18, fontFamily: 'Gilroy Medium',
            ),
          ),
          iconWidget: Stack(
            children: [
              if (createAccount)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF9D34),
                      width: 1,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //(widget.visited == 'budgetVisited')
                      color: step1 ? const Color(0xff85E1B5) : const Color(0xffFFF5E3), //(0xffFF9D34)
                      borderRadius: const BorderRadius.all(Radius.circular(30))),
                  child: SvgPicture.asset(
                    'assets/images/stepperWallet.svg',
                    color: step1 ? Colors.black : const Color(0xffFF9D34),
                  ),
                ),
              ),
            ],
          )),
      StepperData(
        title: StepperText(
          "Step 2",
          textStyle: TextStyle(
            color: step1 ? Colors.black : Colors.grey,
            fontSize: 16,
            fontFamily: 'Gilroy Light',
          ),
        ),
        subtitle: StepperText(
          "Create Budget",
          textStyle: TextStyle(
            color: step1 ? Colors.black : Colors.grey,
            fontSize: 18,
            fontFamily: 'Gilroy Medium',
          ),
        ),
        iconWidget: Stack(
          children: [
            if (budgetCreated)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffFF9D34),
                    width: 1,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: step2 ? const Color(0xff85E1B5) : const Color(0xffFFF5E3), borderRadius: const BorderRadius.all(Radius.circular(30))),
                child: SvgPicture.asset(
                  'assets/images/document.svg',
                  color: step2 ? Colors.black : const Color(0xffFF9D34),
                ),
              ),
            ),
          ],
        ),
      ),
      StepperData(
          title: StepperText(
            "Step 3",
            textStyle: TextStyle(
              color: step2 ? Colors.black : Colors.grey,
              fontSize: 16,
              fontFamily: 'Gilroy Light',
            ),
          ),
          subtitle: StepperText(
            "Create new category",
            textStyle: TextStyle(
              color: step2 ? Colors.black : Colors.grey,
              fontSize: 18,
              fontFamily: 'Gilroy Medium',
            ),
          ),
          iconWidget: Stack(
            children: [
              if (categoryCreated)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF9D34),
                      width: 1,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: step3 ? const Color(0xff85E1B5) : const Color(0xffFFF5E3),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/stepperCategory.svg',
                    color: step3 ? Colors.black : const Color(0xffFF9D34),
                  ),
                ),
              ),
            ],
          )),
      StepperData(
          title: StepperText(
            "Finished",
            textStyle: TextStyle(
              color: step3 ? Colors.black : Colors.grey,
              fontSize: 18,
              fontFamily: 'Gilroy Medium',
            ),
          ),
          iconWidget: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: finished ? const Color(0xff85E1B5) : const Color(0xffFFF5E3), borderRadius: const BorderRadius.all(Radius.circular(30))),
              child: SvgPicture.asset(
                'assets/images/stepperFinish.svg',
                color: finished ? Colors.black : const Color(0xffFF9D34),
              ),
            ),
          )),
    ];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const Text(
                'First Step’s',
                style: TextStyle(fontSize: 25, fontFamily: 'Gilroy Medium', color: Color(0xff1a1a1a)),
              ),
              SvgPicture.asset(
                'assets/svg/dec_line.svg',
                width: width / 3,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50),
                child: AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                  iconWidth: 50,
                  iconHeight: 50,
                  activeBarColor: Colors.green,
                  inActiveBarColor: Colors.grey,
                  inverted: false,
                  verticalGap: 30,
                  activeIndex: widget.activeIndex,
                  barThickness: 1,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: width * 0.42,
                          decoration: const BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                            )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (widget.visited == 'accountVisited') {
                            Get.to(() => const AddAccountType(
                                  fromAccountPage: false,
                                ),transition: Transition.rightToLeftWithFade);
                          }
                          if (widget.visited == 'budgetVisited') {
                            Get.to(() => const AddBudget(),transition: Transition.rightToLeftWithFade);
                          }
                          if (widget.visited == 'categoryVisited') {
                            Get.to(() => const AddBudgetCategory(),transition: Transition.rightToLeftWithFade);
                          }
                          if (widget.visited == 'dashboard') {
                            Get.to(() => HomePage(),transition: Transition.rightToLeftWithFade);
                          }
                        },
                        child: (widget.visited != 'dashboard')
                            ? Container(
                                width: width * 0.42,
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
                              )
                            : Center(
                                child: Container(
                                  width: width * 0.42,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Center(
                                        child: Text(
                                      'Finished',
                                      style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                                    )),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: height * 0.2,
                  // ),
                ],
              ),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
