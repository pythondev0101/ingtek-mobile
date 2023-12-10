import 'package:flutter/material.dart';
import 'package:ingtek_mobile/global_variables.dart';
// import 'package:ingtek_mobile/pages/events_list_page.dart';
import 'package:ingtek_mobile/pages/login_page.dart';
import 'package:ingtek_mobile/utilities/color_utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isLoading = false;

  final _pageController = PageController(initialPage: 0);

  void onTabTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          globalAppBarTitle.value = 'Ingtek';
          break;
        default:
      }
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(globalAppBarTitle.value),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/img/logo.png'),
                  height: 20,
                ),
              ),

              ListTile(
                leading: Icon(Icons.logout),
                title: _isLoading == false
                    ? Text('Logout')
                    : Text('Logging out, please wait...'),
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.delayed(
                      const Duration(milliseconds: 3000), null);
                  setState(() {
                    _isLoading = false;
                  });

                  if(!mounted){return;}

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),
            ],
          ),
        ),
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // EventsPage(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
        ), // new
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
          currentIndex: _currentIndex,
          fixedColor: Colors.deepPurple,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}
