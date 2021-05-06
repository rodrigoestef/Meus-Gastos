import 'package:flutter/material.dart';
import 'pages/graphics.dart';
import 'pages/table.dart';
import 'pages/formNewItem.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(
    MaterialApp(
        title: 'Meus Gastos',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Home()),
  );
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<Widget> _page = <Widget>[Graphics(), TablePage()];
  int _indexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Gastos'),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _page[_indexPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: (int index) {
          setState(() {
            _indexPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: "Grafico"),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: "Tabela"),
        ],
      ),
      floatingActionButton: OpenContainer(
        closedBuilder: (BuildContext c, VoidCallback action) =>
            FloatingActionButton(
          onPressed: action,
          child: Icon(Icons.add),
        ),
        openBuilder: (BuildContext c, VoidCallback action) => FormNewItem(),
        tappable: false,
      ),
    );
  }
}
