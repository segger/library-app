import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app/blocs/blocs.dart';
import 'package:library_app/data/repositories.dart';

import 'package:library_app/providers/providers.dart';

import 'package:library_app/pages/main_page.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final BookRepository bookRepository = BookRepository(
    bookProvider: DBProvider.instance
  );
  final StatsRepository statsRepository = StatsRepository(
    statsProvider: DBProvider.instance
  );

  runApp(LibraryApp(
    bookRepository: bookRepository,
    statsRepository: statsRepository
  ));
}

class LibraryApp extends StatelessWidget {
  final BookRepository bookRepository;
  final StatsRepository statsRepository;

  LibraryApp({Key key, @required this.bookRepository, @required this.statsRepository})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: BlocProviderTree(
        blocProviders: [
          BlocProvider<NavTabsBloc>(
            builder: (context) => NavTabsBloc(),
          ),
          BlocProvider<LibraryBloc>(
            builder: (context) => LibraryBloc(bookRepository: bookRepository)
              ..dispatch(LoadLibraryEvent()),
          ),
          BlocProvider<StatsBloc>(
            builder: (context) => StatsBloc(statsRepository)
            ..dispatch(LoadYearStatsEvent()),
          )
        ],
        child: MainPage(),
      ),
    );
  }
}
