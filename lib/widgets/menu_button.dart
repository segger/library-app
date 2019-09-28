import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app/blocs/blocs.dart';
import 'package:library_app/data/repositories.dart';
import 'package:library_app/data/stats_repository.dart';
import 'package:library_app/providers/providers.dart';
import 'package:library_app/views/add_book_form.dart';
import 'package:library_app/views/export_year_form.dart';

class MenuButton extends StatefulWidget {
  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
  with SingleTickerProviderStateMixin {

  LibraryBloc _libraryBloc;
  StatsBloc _statsBloc;

  bool menuOpen = false;
  AnimationController _menuController;
  Animation<Color> _menuColor;
  Animation<double> _menuIcon;
  Animation<double> _menuPos;

  @override
  void initState() {
    _libraryBloc = BlocProvider.of<LibraryBloc>(context);
    _statsBloc = BlocProvider.of<StatsBloc>(context);
    _initMenu();
    super.initState();
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  _initMenu() {
    _menuController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    )..addListener(() { setState(() {}); } );
    _menuIcon = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(_menuController);
    _menuColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red
    ).animate(_menuController);
    _menuPos = Tween<double>(
      begin: 56.0,
      end: -14.0
    ).animate(_menuController);
  }

  _toggleMenu() {
    if(!menuOpen) {
      _menuController.forward();
    } else {
      _menuController.reverse();
    }
    menuOpen = !menuOpen;
  }

  _addNewBook() {
    _toggleMenu();
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddBookForm(
          onSave: (book) {
            _libraryBloc.dispatch(AddBookLibraryEvent(book));
            _statsBloc.dispatch(AddBookStatsEvent(date: book.date));
          }
        )
      )
    );
  }

  _exportDialog() {
    _toggleMenu();
    StatsRepository statsRepository = StatsRepository(statsProvider: DBProvider.instance);
    StorageRepository storageRepository = StorageRepository(storageProvider: StorageProvider.instance);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return BlocProvider<ExportBloc>(
          builder: (context) => ExportBloc(statsRepository, storageRepository)..dispatch(LoadExportYearsEvent()),
          child: ExportYearForm(),
        );
      }
    ));
  }

  Widget _exportMenuItem() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'export',
        onPressed: _exportDialog,
        tooltip: 'Exportera',
        child: Icon(Icons.import_export),
      ),
    );
  }

  Widget _addNewBookMenuItem() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'book',
        onPressed: _addNewBook,
        tooltip: 'Add new book',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _addNewMenu() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'menu',
        backgroundColor: _menuColor.value,
        onPressed: _toggleMenu,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _menuIcon
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0, _menuPos.value * 2.0, 0.0
          ),
          child: _exportMenuItem()
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0, _menuPos.value, 0.0
          ),
          child: _addNewBookMenuItem()
        ),
        _addNewMenu(),
      ],
    );
  }
}