class Note{
  int id;
  String color;
  int time_start;
  int time_finish;
  int date_start;
  int date_finish;
  String name;
  String description;

  Note({
    required this.id,
    required this.color,
    required this.time_start,
    required this.time_finish,
    required this.date_start,
    required this.date_finish,
    required this.name,
    required this.description
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      color: json['color'],
      time_start: json['time_start'],
      time_finish: json['time_finish'],
      date_start: json['date_start'],
      date_finish: json['date_finish'],
      name: json['name'],
      description: json['description']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'color': color,
    'time_start': time_start,
    'time_finish': time_finish,
    'date_start': date_start,
    'date_finish': date_finish,
    'name': name,
    'description': description
  };
}