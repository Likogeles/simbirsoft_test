class Note{
  int id;
  String date_start;
  String date_finish;
  String name;
  String description;

  Note({
    required this.id,
    required this.date_start,
    required this.date_finish,
    required this.name,
    required this.description
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      date_start: json['date_start'],
      date_finish: json['date_finish'],
      name: json['name'],
      description: json['description']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_start': date_start,
    'date_finish': date_finish,
    'name': name,
    'description': description
  };
}