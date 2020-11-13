import 'package:flutter/material.dart';
import 'package:library_app/blocs/nav_tabs.dart';

class TabSelector extends StatelessWidget {
  final NavTabs activeTab;
  final Function(NavTabs) onTabSelected;
  
  TabSelector({Key key, @required this.activeTab, @required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: NavTabs.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(NavTabs.values[index]),
      items: NavTabs.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == NavTabs.books ? Icons.list : Icons.show_chart,
          ),
          label: tab == NavTabs.books ? 'Books' : 'Stats',
        );
      }).toList(),
    );
  }
}