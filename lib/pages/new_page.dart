import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:intl/intl.dart';
import 'package:simbirsoft_test/classes/note.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:path_provider/path_provider.dart';

class newPage extends StatefulWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  _newPageState createState() => _newPageState();
}

class _newPageState extends State<newPage> {
  DateTime date = DateTime.now();
  TimeRange timeRange = TimeRange(
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 21, minute: 0));
  String name = "Название";
  String description = "Описание";

  Future pickDate(BuildContext context) async {
    final initialDate = date;

    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      helpText: "Выбор диапазона дат дела",
      cancelText: "Отмена",
      confirmText: "Принять",
    );
    if (newDate == null) return;

    setState(() => date = newDate);
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
      labels: ["24", "3", "6", "9", "12", "15", "18", "21"]
          .asMap()
          .entries
          .map((e) {
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

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/notes.json'; // 3
    print(filePath);
    return filePath;
  }

  saveJsonFile(String name, String description, DateTime date,
      TimeRange timeRange) async {
    final responce =
        await rootBundle.rootBundle.loadString("lib/jsonfiles/notes.json");
    final data = await json.decode(responce) as List<dynamic>;

    int id = data[data.length - 1]['id'];
    Note item = new Note(
      id: id,
      color: "00B8D0",
      time_start: timeRange.startTime.hour,
      time_finish: timeRange.endTime.hour,
      date_start: date.millisecondsSinceEpoch ~/ 1000,
      date_finish: date.millisecondsSinceEpoch ~/ 1000,
      name: name,
      description: description,
    );

    data.add(item.toJson());

    /*
    try {
      print(await getApplicationSupportDirectory());
      File file = File(await getFilePath()); // 1
      file.writeAsStringSync(data.toString());
    } catch (ex) {
      print('');
      print(ex);
    }
    */

    print('');
    print(data);
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
                    Text("Дата: ", style: TextStyle(fontSize: 20)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(date),
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pickDate(context);
                      },
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
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pickTime(context, 0);
                      },
                    ),
                    Icon(Icons.arrow_right_alt),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "${timeRange.endTime.hour.toString().padLeft(2, '0')}:${timeRange.endTime.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pickTime(context, 1);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Добавить", style: TextStyle(fontSize: 16)),
        icon: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          saveJsonFile(name, description, date, timeRange);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
