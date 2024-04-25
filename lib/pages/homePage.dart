import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance_management/pages/HomeScreens/accounts_view.dart';
import 'package:personal_finance_management/pages/HomeScreens/dashboard_view.dart';
import 'package:personal_finance_management/pages/HomeScreens/transaction_view.dart';
import 'package:personal_finance_management/pages/Reminder/new_reminder.dart';

class HomePage extends StatefulWidget {
  int? index;
  int? passedIndex;
  HomePage({Key? key, this.index, this.passedIndex}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExtended = false;
  int _currentIndex = 0;

  bool fabVisible = true;
  bool bottomNav = true;

  final List<Widget> _pageList = [
    const DashboardPage(),
    const NewReminder(),
    const TransactionPage(),
    const AccountsPage(),
  ];
  final HideNavbar hiding = HideNavbar();

  @override
  void initState() {
    widget.index == 1 ? _currentIndex = 1 : null;
    if (widget.passedIndex != null) {
      setState(() {
        _currentIndex = widget.passedIndex!;
      });
    }
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: bottomNav
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: onTabTapped,
                  elevation: 16.0,
                  showUnselectedLabels: true,
                  unselectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: "Gilroy Medium"),
                  unselectedItemColor: const Color(0xff8a8a8a),
                  selectedItemColor: Colors.black,
                  selectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: "Gilroy SemiBold"),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/activeHomeMenu.svg'),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/inactiveHomeMenu.svg'),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/activeRemMenu.svg'),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/inactiveRemMenu.svg'),
                      ),
                      label: 'Reminder',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/activeTransactionMenu.svg'),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/inactiveTransactionMenu.svg'),
                      ),
                      label: 'Transaction',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/activeAccountsMenu.svg'),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SvgPicture.asset('assets/svg/inactiveAccountsMenu.svg'),
                      ),
                      label: 'Accounts',
                    ),
                  ],
                ),
              )
            : null,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                fabVisible = true;
                bottomNav = true;
                isExtended = false;
              });
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isExtended = true;
                fabVisible = false;
                bottomNav = false;
              });
            }
            return true;
          },
          child: _pageList[_currentIndex],

        ),
      ),
    );
  }
}

class HideNavbar {
  final ScrollController controller = ScrollController();
  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  HideNavbar() {
    visible.value = true;
    controller.addListener(
      () {
        if (controller.position.userScrollDirection == ScrollDirection.reverse) {
          if (visible.value) {
            visible.value = false;
          }
        }

        if (controller.position.userScrollDirection == ScrollDirection.forward) {
          if (!visible.value) {
            visible.value = true;
          }
        }
      },
    );
  }

  void dispose() {
    controller.dispose();
    visible.dispose();
  }
}
