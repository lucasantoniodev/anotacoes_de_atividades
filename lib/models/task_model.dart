// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaskModel {
  int? id;
  late String title;
  late String description;
  late int completed;

  TaskModel({
    required this.title,
    required this.description,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "title": title,
      "description": description,
      "completed": completed
    };
    return json;
  }

  TaskModel.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
  }
}
