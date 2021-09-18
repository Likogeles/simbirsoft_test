import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class newPage extends StatefulWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  _newPageState createState() => _newPageState();
}

class _newPageState extends State<newPage> {
  late DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  TimeOfDay selected_time_1 = TimeOfDay.now();
  TimeOfDay selected_time_2 = TimeOfDay.now();
  String name = "Название";
  String description = "Описание";

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    
    
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
    final initialTime = TimeOfDay.now();
    final newTime = await showTimePicker(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      helpText: (n == 0) ? "Время начала" : "Время окончания",
      cancelText: "Отмена",
      confirmText: "Принять",
      context: context,
      initialTime: initialTime,
    );

    if (newTime == null) return;
    if (n == 0)
      setState(() => selected_time_1 = newTime);
    else
      setState(() => selected_time_2 = newTime);
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
                    Text("Время начала: ", style: TextStyle(fontSize: 20)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(

                        "${selected_time_1.hour.toString().padLeft(2, '0')}:${selected_time_1.minute.toString().padLeft(2, '0')}",

                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => pickTime(context, 0),
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
                    Text("Время окончания: ", style: TextStyle(fontSize: 20)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "${selected_time_2.hour.toString().padLeft(2, '0')}:${selected_time_2.minute.toString().padLeft(2, '0')}",
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
