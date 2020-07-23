import "package:flutter/material.dart";

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _name;

  CustomAppBar(this._name);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_name, style: TextStyle(color: Colors.white)),
      flexibleSpace: Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)]),
      )),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.white),
          onPressed: null,
          color: Colors.white,
        ),
      ],
      iconTheme: new IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
