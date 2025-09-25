class Todo {
  final String id;
  String title;
  bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  // Untuk membuat salinan objek
  Todo copyWith({String? id, String? title, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
