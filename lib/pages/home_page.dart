import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text('List:'),
            centerTitle: true,
          ),
        ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 140.0,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2077),
                  calendarFormat: format,
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
                  ),
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
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
                  return Container(
                    color: index.isOdd ? Colors.white : Colors.black12,
                    height: 50.0,
                    child: ListTile(
                      leading: Text(
                          '${(index ~/ 10).toString() + (index % 10).toString()}:00'),
                    ),
                  );
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
          onPressed: () {},
        ),
      ),
    );
  }
}
