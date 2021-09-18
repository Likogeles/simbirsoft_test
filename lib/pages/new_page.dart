import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class newPage extends StatefulWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  _newPageState createState() => _newPageState();
}

class _newPageState extends State<newPage> {
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  TimeRange timeRange =
      TimeRange(startTime: TimeOfDay(hour: 8, minute: 0), endTime: TimeOfDay(hour: 21, minute: 0));
  String name = "Название";
  String description = "Описание";

  List<ClockLabel> clockLabels = [
    ClockLabel(angle: -90, text: '0'),
    ClockLabel(angle: 0, text: '6'),
    ClockLabel(angle: 90, text: '12'),
    ClockLabel(angle: 180, text: '18'),
  ];

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = dateRange;

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: initialDateRange,
      helpText: "Выбор диапазона дат дела",
      cancelText: "Отмена",
      confirmText: "Принять",
      saveText: "Сохранить",
    );
    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  Future pickTime(BuildContext context, int n) async {
    final initialTimeRange = timeRange;
    final newTimeRange = await showTimeRangePicker(
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 21, minute: 0),
      interval: Duration(minutes: 60),
      clockRotation: 180,
      toText: "До",
      fromText: "От",
      ticks: 24,
      labels:
          ["24", "3", "6", "9", "12", "15", "18", "21"].asMap().entries.map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      padding: 50,
      labelOffset: 30,
      context: context,
      strokeWidth: 10,
      ticksOffset: -7,
      ticksLength: 30,
      rotateLabels: false,
    );

    if (newTimeRange == null) return;
    setState(() => timeRange = newTimeRange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавление дела"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: name,
                    labelText: "Название",
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) {
                    name = text;
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: description,
                    labelText: "Краткое описание дела",
                    labelStyle: TextStyle(fontSize: 20),
                    hintStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) {
                    description = text;
                  },
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3),
                  top: BorderSide(width: 3),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text("Даты: ", style: TextStyle(fontSize: 20)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(dateRange.start),
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => pickDateRange(context),
                    ),
                    Icon(Icons.arrow_right_alt),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(dateRange.end),
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => pickDateRange(context),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text("Время: ", style: TextStyle(fontSize: 20)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "${timeRange.startTime.hour.toString().padLeft(2, '0')}:${timeRange.startTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => pickTime(context, 0),
                    ),
                    Icon(Icons.arrow_right_alt),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "${timeRange.endTime.hour.toString().padLeft(2, '0')}:${timeRange.endTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => pickTime(context, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
