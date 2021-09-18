import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
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

  Future<List<Note>> getNotes() async {
    final responce =
        await rootBundle.rootBundle.loadString("lib/jsonfiles/notes.json");
    final data = await json.decode(responce) as List<dynamic>;

    return data
        .map((e) => Note.fromJson(e))
        .toList()
        .where((e) => (checkDate(e)))
        .toList();
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.name),
        content: Text(item.description),
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
                                child: (item.time_start <= index &&
                                        item.time_finish >= index)
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
