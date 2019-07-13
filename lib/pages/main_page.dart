import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app/blocs/blocs.dart';

import 'package:library_app/pages/books_page.dart';
import 'package:library_app/pages/stats_page.dart';

import 'package:library_app/widgets/add_menu_button.dart';
import 'package:library_app/widgets/tab_selector.dart';
import 'package:library_app/widgets/sort_order_icon.dart';

import 'package:library_app/models/constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NavTabsBloc _tabBloc;

  SortOrder _sortOrder = SortOrder.date;

  // Reload
  LibraryBloc _libraryBloc;
  StatsBloc _statsBloc;

  @override
  void initState() {
    _tabBloc = BlocProvider.of<NavTabsBloc>(context);
    // Reload
    _libraryBloc = BlocProvider.of<LibraryBloc>(context);
    _statsBloc = BlocProvider.of<StatsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _tabBloc,
      builder: (BuildContext context, NavTabs activeTab) {
        return Scaffold(
          appBar: _appBar(activeTab),
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

  Widget _appBar(NavTabs activeTab) {
    return AppBar(
      title: Text('Library'),
      actions: <Widget>[
        activeTab == NavTabs.books ? SortOrderIcon(
          onSortOrderUpdated: (sortOrder) {
            _sortOrder = sortOrder;
            _libraryBloc.dispatch(SortLibraryEvent(_sortOrder));
          }
        ) : Container(),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            // Reload
            _libraryBloc.dispatch(LoadLibraryEvent());
            _statsBloc.dispatch(LoadYearStatsEvent());
          },
        ),
      ]
    );
  }
}
