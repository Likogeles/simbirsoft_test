import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simbirsoft_test/classes/note.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCustomScrollView extends StatefulWidget {
  const MyCustomScrollView({Key? key}) : super(key: key);

  @override
  _MyCustomScrollViewState createState() => _MyCustomScrollViewState();
}

class _MyCustomScrollViewState extends State<MyCustomScrollView> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  Directory? dir = null;
  File? jsonFile = null;
  List<dynamic>? fileContent = [];

  String fileName = "notes.json";
  bool fileExist = false;

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir!.path + '/' + fileName);
      fileExist = jsonFile!.existsSync();

      if (!fileExist) createFile([], dir!, fileName);

      this.setState(() {
        fileContent = json.decode(jsonFile!.readAsStringSync());
      });
    });
  }

  void createFile(List<dynamic> content, Directory dir, String fileName) {
    File file = new File(dir.path + '/' + fileName);
    file.createSync();
    fileExist = true;
    file.writeAsStringSync(json.encode(content));
  }

  Future<List<Note>> getNotes() async {

    List<dynamic> jsonFileContent =
        await json.decode(jsonFile!.readAsStringSync());
    List<Note> newList = [];

    for (dynamic item in jsonFileContent) {
      Note newNote = new Note(
          id: item['id'],
          color: item['color'],
          time_start: item['time_start'],
          time_finish: item['time_finish'],
          date_start: item['date_start'],
          date_finish: item['date_finish'],
          name: item['name'],
          description: item["description"]);
      newList.add(newNote);
    }

    this.setState(() {});
    return newList.where((e) => (checkDate(e))).toList();
  }

  bool checkDate(Note e) {
    DateTime a = DateTime.fromMillisecondsSinceEpoch(e.date_start * 1000);
    DateTime b = selectedDay;
    DateTime c = DateTime.fromMillisecondsSinceEpoch(e.date_finish * 1000);

    if (a.year <= b.year &&
        a.month <= b.month &&
        a.day <= b.day &&
        b.year <= c.year &&
        b.month <= c.month &&
        b.day <= c.day) return true;
    return false;
  }

  String timeFromIndex(int index) {
    if (index < 24 - 7)
      return '${((index + 7) ~/ 10).toString() + ((index + 7) % 10).toString()}:00';
    return '${((index - 17) ~/ 10).toString() + ((index - 17) % 10).toString()}:00';
  }

  showDialogToDo(Note item) {
    String text = item.description +
        "\n\nДата:\n\t" +
        DateFormat('dd-MM-yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(item.date_start * 1000)) +
        "\n\nВремя:\n\t" +
        "${item.time_start.toString().padLeft(2, '0')}:00";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.name),
        content: Text(text),
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
              delToDo(item.id);
            },
            child: Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  delToDo(int id){

    List<dynamic> jsonFileContent = json.decode(jsonFile!.readAsStringSync());

    jsonFileContent = jsonFileContent.where((e) => (e['id'] != id)).toList();
    

    for(int i =0; i < jsonFileContent.length; i++){
      jsonFileContent[i]['id'] = i;
    }

    if (fileExist) {
      jsonFile!.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      createFile(jsonFileContent, dir!, fileName);
    }

    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey[100],
          expandedHeight: 140.0,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime(DateTime.now().year - 5),
              lastDay: DateTime(DateTime.now().year + 5),
              calendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white)),
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  rightChevronMargin: EdgeInsets.only(right: 100)),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                // Смена дня в календаре
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
            ),
            centerTitle: true,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return FutureBuilder(
                future: getNotes(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Center(child: Text('${data.error}'));
                  } else if (data.hasData) {
                    var items = data.data as List<Note>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      elevation: 6,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color:
                            index.isOdd ? Colors.grey[200] : Colors.grey[300],
                        height: 70.0,
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text(
                                '${index.toString().padLeft(2, '0')}:00',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            for (var item in items)
                              Expanded(
                                child: ((item.time_start <= index &&
                                        item.time_finish >= index))
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Color(
                                              int.parse("0xff" + item.color)),
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.redAccent.shade100,
                                              width: 2.0,
                                            ),
                                            right: BorderSide(
                                              color: Colors.redAccent.shade100,
                                              width: 3.0,
                                            ),
                                            top: (item.time_start == index)
                                                ? BorderSide(
                                                    color: Colors
                                                        .redAccent.shade100,
                                                    width: 3.0,
                                                  )
                                                : BorderSide(
                                                    color: Colors.transparent),
                                            bottom: (item.time_finish == index)
                                                ? BorderSide(
                                                    color: Colors
                                                        .redAccent.shade100,
                                                    width: 3.0,
                                                  )
                                                : BorderSide(
                                                    color: Colors.transparent),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        height: 70,
                                        child: ButtonTheme(
                                          minWidth: double.infinity,
                                          height: double.infinity,
                                          child: MaterialButton(
                                              child: (item.time_start == index)
                                                  ? Text(
                                                      item.name,
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : SizedBox(),
                                              onPressed: () => showDialogToDo(
                                                  item) // Нажатие на кнопку дела (на само дело)
                                              ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(width: 30),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            },
            childCount: 24,
          ),
        ),
      ],
    );
  }
}
