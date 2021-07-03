
import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/models/consts.dart';

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

class AppBarPattern extends StatelessWidget implements PreferredSizeWidget {
  final String titleScreen;
  final List<Widget> actions;
  const AppBarPattern({Key key, this.titleScreen, this.actions}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Color(systemPrimaryColor),),
      centerTitle: true,
      title: Text(
        titleScreen,
        style: TextStyle(color: Color(systemPrimaryColor),),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: actions,
    );
  }

}