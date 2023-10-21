import 'package:flutter/material.dart';
import 'package:stopwatch_tugas/about.dart';
import 'package:stopwatch_tugas/stopwatch.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardPage> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    DateTime currentBackPressTime;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              // Here we create one to set status bar color
              backgroundColor: Colors.blue,
              // Set any color of status bar you want; or it defaults to your theme's primary color
            )),
        body: SafeArea(
          child: IndexedStack(
            index: tabIndex,
            children: [CountDownTimerPage(), AboutPage()],
          ),
        ),
        bottomNavigationBar: SizedBox(

            //height : 40;
            child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x1ABABABA),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 10), // changes position of shadow
              ),
            ],
            border: Border(
                // top: BorderSide(width: 0, color: kDarkGrey),
                ),
          ),
          child: BottomNavigationBar(
            unselectedItemColor: Colors.grey[300],
            selectedItemColor: Colors.red[600],
            onTap: (index) {
              setState(() {
                tabIndex = index;
              });
            },
            currentIndex: tabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                activeIcon: Icon(Icons.timer),
                label: 'Countdown',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                activeIcon: Icon(Icons.account_circle_outlined),
                label: 'About',
              ),
            ],
            selectedLabelStyle: const TextStyle(fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontSize: 15),
          ),
        )));
  }
}
