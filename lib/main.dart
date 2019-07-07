import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app/blocs/blocs.dart';

import 'package:library_app/pages/main_page.dart';

void main() => runApp(LibraryApp());

class LibraryApp extends StatelessWidget {
  // This widget is the root of your application.
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
        ],
        child: MainPage(),
      ),
    );
  }
}
