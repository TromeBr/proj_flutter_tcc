
import 'package:flutter/material.dart';

class PaddingWidgetPattern extends StatelessWidget {
  final double _paddingValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_paddingValue),
    );
  }

  PaddingWidgetPattern(this._paddingValue);
}

