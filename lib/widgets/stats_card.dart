import 'package:flutter/material.dart';

class StatsCard extends StatefulWidget {
  @override  
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  int year = 2019;
  int count = 42;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: _title(year, count),
        children: _expandedContent(),
      ),
    );
  }

  _title(int year, int count) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(year.toString(),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: <Widget>[
              Text('Totalt: '),
              Text(count.toString()),
            ],
          ),
        ),
      ],
    );
  }

  _expandedContent() {
    List<Widget> expandedContent = new List<Widget>();
    // expandedYear.add(_exportIcon(year));
    // expandedYear.addAll(months.map((month) => _monthRow(month)));
    expandedContent.add(_monthRow());
    return expandedContent;
  }

  _monthRow() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('July'),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '42',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}