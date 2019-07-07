import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app/blocs/blocs.dart';

import 'package:library_app/pages/books_page.dart';
import 'package:library_app/pages/stats_page.dart';

import 'package:library_app/widgets/add_menu_button.dart';
import 'package:library_app/widgets/tab_selector.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NavTabsBloc _tabBloc;

  @override
  void initState() {
    _tabBloc = BlocProvider.of<NavTabsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _tabBloc,
      builder: (BuildContext context, NavTabs activeTab) {
        return Scaffold(
          appBar: _appBar(),
          body: activeTab == NavTabs.books ? BooksPage() : StatsPage(),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => _tabBloc.dispatch(ChangeTabEvent(tab: tab)),
          ),
          floatingActionButton: AddMenuButton(),
        );
      },
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('Library'),
    );
  }
}
