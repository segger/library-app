import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/blocs/stats.dart';

import 'package:library_app/models/stats.dart';

class StatsCard extends StatefulWidget {
  final Stats stats;

  StatsCard({Key key, @required this.stats}) : assert(stats != null);

  @override
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  StatsBloc _bloc;

  //final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();

  @override
  void initState() {
    _bloc = BlocProvider.of<StatsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: _title(),
        onExpansionChanged: (open) {
          if (open) {
            _bloc.add(LoadMonthStatsEvent(year: int.parse(widget.stats.name)));
          }
        },
        children: _expansionContent(),
      ),
    );
  }

  Widget _title() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(widget.stats.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: <Widget>[
              Text('Totalt: '),
              Text(widget.stats.count.toString()),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _expansionContent() {
    List<Widget> expandedContent = List.empty(growable: true);
    // expandedYear.add(_exportIcon(year));

    List<MonthStats> monthStats = (widget.stats as YearStats).monthStats;
    expandedContent.addAll(monthStats.map((month) => _monthRow(month)));

    return expandedContent;
  }

  _monthRow(MonthStats month) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(month.name),
          ),
          Expanded(
            flex: 2,
            child: Text(
              month.count.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
