import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/selectedIndex.dart';
import '/views/pages/home_page.dart';
import '/views/pages/add_page.dart';

class AuthenticatedView extends StatelessWidget {
  final List<Widget> _pages = [
    HomePage(),
    HomePage(isTrashed: true),
    AddPage(),
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
                labelType: NavigationRailLabelType.selected,
                destinations: [
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
                ],
              )),
        ],
      ),
    );
  }
}
