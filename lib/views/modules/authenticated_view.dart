import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/user_authentication.dart';
import '/helpers/authentication_helper.dart';
import '/views/pages/sheet_page.dart';
// import '../helpers/selectedIndex.dart';
import '/helpers/selectedIndex.dart';
import '/views/pages/home_page.dart';
import '/views/pages/add_page.dart';

class AuthenticatedView extends StatelessWidget {
  final List<Widget> _pages = [
    HomePage(),
    HomePage(isTrashed: true),
    AddPage(),
    SheetPage(),
  ];

  void _onItemTapped(int index) {
    selectedIndex.state.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Overtime'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Obx(() => _pages[selectedIndex.state.value]),
          ),
          Obx(() => NavigationRail(
                selectedIndex: selectedIndex.state.value,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.app_blocking),
                    label: Text('Trash'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.table_chart_outlined),
                    label: Text('Sheets'),
                  ),
                ],
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            print('logout');
                            logoutUser();
                            print('logout');
                            is_authenticated.value = false;
                          }),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
