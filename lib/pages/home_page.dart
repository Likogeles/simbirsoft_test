import 'package:flutter/material.dart';
import 'package:simbirsoft_test/widgets/MyCustomScrollView.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

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
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(''),
              content: Text(''),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.delete),
                )
              ],
            ),
          );
        },
        backgroundColor: Colors.blue[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
