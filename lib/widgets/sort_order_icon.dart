import 'package:flutter/material.dart';
import 'package:library_app/models/constants.dart';

typedef OnSortOrderUpdatedCallback = Function(SortOrder sortOrder);

class SortOrderIcon extends StatefulWidget {
  final OnSortOrderUpdatedCallback onSortOrderUpdated;

  SortOrderIcon({@required this.onSortOrderUpdated});

  @override
  _SortOrderIconState createState() => _SortOrderIconState();
}

class _SortOrderIconState extends State<SortOrderIcon> {

  SortOrder _sortOrder = SortOrder.date;

  _getNewOrder(SortOrder order) {
    switch(order) {
      case SortOrder.date:
        return SortOrder.title;
      case SortOrder.title:
        return SortOrder.author;
      case SortOrder.author:
        return SortOrder.date;
    }
  }

  _sortLibrary() {
    _sortOrder = _getNewOrder(_sortOrder);
    widget.onSortOrderUpdated(_sortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sort),
      onPressed: () {
        _sortLibrary();
        Scaffold.of(context).showSnackBar(_notifySortOrderUpdated());
      }
    );
  }

  _getSortOrderLabel(SortOrder order) {
    switch(order) {
      case SortOrder.date:
        return "datum";
      case SortOrder.title:
        return "titel";
      case SortOrder.author:
        return "författare";
      default:
        return "";
    }
  }

  SnackBar _notifySortOrderUpdated() {
    return SnackBar(
      content: Text('Sorterar på ' + _getSortOrderLabel(_sortOrder)),
      duration: Duration(milliseconds: 1000),
    );
  }
}