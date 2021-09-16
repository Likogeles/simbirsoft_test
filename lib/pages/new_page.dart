import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class newPage extends StatefulWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  _newPageState createState() => _newPageState();
}

class _newPageState extends State<newPage> {
  DateTime selectedDay_1 = DateTime.now();
  DateTime focusedDay_1 = DateTime.now();
  DateTime selectedDay_2 = DateTime.now();
  DateTime focusedDay_2 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавление дела"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Дата начала",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3),
                top: BorderSide(width: 3),
              ),
            ),
            child: TableCalendar(
              focusedDay: focusedDay_1,
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
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                // Смена дня в календаре
                setState(() {
                  selectedDay_1 = selectDay;
                  focusedDay_1 = focusDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay_1, date);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Дата окончания",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3),
                top: BorderSide(width: 3),
              ),
            ),
            child: TableCalendar(
              focusedDay: focusedDay_2,
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
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                // Смена дня в календаре
                setState(() {
                  selectedDay_2 = selectDay;
                  focusedDay_2 = focusDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay_2, date);
              },
            ),
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
