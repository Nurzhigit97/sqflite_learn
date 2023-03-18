class DBTodo {
  int id;
  String title;
  String description;
  DBTodo({
    this.id = 0,
    this.title = '',
    this.description = '',
  });

  factory DBTodo.fromMap(Map<String, dynamic> json) => DBTodo(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
