import "package:flutter/material.dart";
import 'package:kudabin/ScopedModels/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _name;

  CustomAppBar(this._name);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
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
            model.notify
                ? IconButton(
                    icon: Icon(Icons.notifications_active),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(model.notifications[0]["title"]),
                              content: Text(model.notifications[0]["body"]),
                            );
                          });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: null,
                    color: Colors.white,
                  ),
          ],
          iconTheme: new IconThemeData(color: Colors.white),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
