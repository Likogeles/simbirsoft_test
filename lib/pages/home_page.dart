import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:simbirsoft_test/classes/note.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  Future<List<Note>> getNotes() async {
    final responce =
        await rootBundle.rootBundle.loadString("lib/jsonfiles/notes.json");
    final data = await json.decode(responce) as List<dynamic>;
    return data.map((e) => Note.fromJson(e)).toList();
  }

  String timeFromIndex(int index) {
    if (index < 24 - 7)
      return '${((index + 7) ~/ 10).toString() + ((index + 7) % 10).toString()}:00 ';
    return '${((index - 17) ~/ 10).toString() + ((index - 17) % 10).toString()}:00';
  }

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[100],
            expandedHeight: 140.0,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime(1990),
                lastDay: DateTime(2077),
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
                            color: index.isOdd
                                ? Colors.grey[200]
                                : Colors.grey[300],
                            height: 70.0,
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  alignment: Alignment.center,
                                  child: Text(
                                    timeFromIndex(index),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                for (var item in items)
                                  Expanded(
                                    child: (item.time_start <= index + 7 &&
                                            item.time_finish >= index + 7)
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: 70,
                                            color: Color(
                                                int.parse("0xff" + item.color)),
                                            child: ButtonTheme(
                                              minWidth: double.infinity,
                                              height: double.infinity,
                                              child: MaterialButton(
                                                child: (item.time_start ==
                                                        index + 7)
                                                    ? Text(item.name)
                                                    : SizedBox(),
                                                onPressed: () {
                                                  // Нажатие на кнопку дела (на само дело)
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    });
              },
              childCount: 24,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
        onPressed: () {
          //Нажатие на плавающую кнопку (справа сверху)
        },
        backgroundColor: Colors.blue[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
