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

  int itemscount = 0;

  Future<List<Note>> loadNotes() async {
    final responce =
        await rootBundle.rootBundle.loadString("lib/jsonfiles/notes.json");
    final data = await json.decode(responce) as List<dynamic>;
    itemscount = data.length;
    return data.map((e) => Note.fromJson(e)).toList();
  }

  Future<List<Note>> getNotes() async {
    return loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                          if (index < items.length)
                            return Card(
                              elevation: 6,
                              child: Container(
                                color: index.isOdd
                                    ? Colors.grey[200]
                                    : Colors.grey[300],
                                height: 70.0,
                                child: ListTile(
                                  leading: Padding(
                                    child: Text(
                                      '${items[index].name}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                  ),
                                  title: Text('Named ${index}'),
                                  subtitle: Text('Subtext ${index}'),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          else
                            return Text('');
                        }
                        return Center(child: CircularProgressIndicator());
                      });
                },
                childCount: 999,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40.0,
          ),
          onPressed: () {},
          backgroundColor: Colors.blue[800],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }
}
