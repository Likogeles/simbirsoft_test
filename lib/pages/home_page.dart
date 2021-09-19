import 'package:flutter/material.dart';
import 'package:simbirsoft_test/pages/new_page.dart';
import 'package:simbirsoft_test/widgets/MyCustomScrollView.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Даты запланнированных дел в json:
// 12 сентября
// 13 сентября
// 19 сентября

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Дела:'),
          centerTitle: true,
        ),
      ),
      body: MyCustomScrollView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
        onPressed: () {
          //Нажатие на плавающую кнопку (справа сверху)
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>newPage()));
        },
        backgroundColor: Colors.blue[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
