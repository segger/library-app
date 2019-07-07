import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class LoadingError extends StatefulWidget {
  LoadingError({Key key, this.errorText}) : super(key: key);

  final String errorText;

  @override
  _LoadingErrorState createState() => _LoadingErrorState();
}
  
class _LoadingErrorState extends State<LoadingError> {
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.errorText));
  }
}