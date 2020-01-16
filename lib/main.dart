import 'package:flutter/material.dart';
import 'package:poodo/todo_page.dart';
import 'package:poodo/memo_page.dart';
import 'package:poodo/want_page.dart';
import 'package:poodo/theme.dart';
import 'package:poodo/db_provider.dart';

void main() => runApp(MainApp());

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class MainApp extends StatelessWidget {
  final List<TabInfo> _tabs = [
    TabInfo("todo", TodoPage()),
    TabInfo("want", WantPage()),
    TabInfo("memo", MemoPage()),
  ];

  final List<String> _settingMenu = [
    "Color theme (TBD)",
    "Clear database",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: DefaultTabController(
          length: _tabs.length,
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('poodo'),
                  actions: <Widget>[
                    PopupMenuButton(
                      icon: Icon(Icons.settings),
                      onSelected: (String s) {
                        switch (s) {
                          case "Clear database":
                            showConfirmationDialog(context);
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return _settingMenu.map((String s) {
                          return PopupMenuItem(
                            child: Text(s),
                            value: s,
                          );
                        }).toList();
                      },
                    )
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    unselectedLabelStyle: TextStyle(fontSize: 12.0),
                    labelColor: Colors.yellowAccent,
                    labelStyle: TextStyle(fontSize: 16.0),
                    indicatorColor: Colors.white,
                    indicatorWeight: 2.0,
                    tabs: _tabs.map((TabInfo tab) {
                      return Tab(text: tab.label);
                    }).toList(),
                  ),
                ),
                body: TabBarView(
                  children: _tabs.map((tab) => tab.widget).toList(),
                ),
              );
            },
          ),
        ));
  }

  void showConfirmationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("You are sure to clear the database?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
                child: Text("OK"),
                onPressed: () {
                  DbProvider().clearDB();
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
