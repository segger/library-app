import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:library_app/blocs/stats.dart';

import 'package:library_app/widgets/load_components.dart';
import 'package:library_app/widgets/stats_card.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<StatsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, StatsState state) {
          if (state is StatsInit) {
            return Loading();
          }
          if (state is StatsError) {
            return LoadingError(errorText: 'Failed to get stats');
          }
          if (state is StatsLoaded) {
            return _statsList(state);
          }
          return null;
        });
  }

  Widget _statsList(StatsLoaded state) {
    return ListView.builder(
      itemCount: state.stats.length,
      itemBuilder: (context, position) {
        return Slidable(
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [],
          ),
          endActionPane: ActionPane(motion: const DrawerMotion(), children: [
            SlidableAction(
                label: 'Delete',
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (context) {
                  _bloc.dispatch(DeleteYearEvent(
                      year: int.parse(state.stats[position].name)));
                }),
          ]),
          child: StatsCard(stats: state.stats[position]),
        );
      },
    );
  }
}
