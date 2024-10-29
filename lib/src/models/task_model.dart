class TaskModel {
  String title;
  String description;
  String file;
  double? fileSize;
  String fileType;
  DateTime createdDate;
  DateTime updatedDate;
  DateTime deadlineDate;
  String teacherName;
  String teacherId;

  TaskModel({
    required this.title,
    required this.description,
    required this.file,
    required this.fileType,
    required this.updatedDate,
    required this.createdDate,
    required this.deadlineDate,
    required this.teacherId,
    this.fileSize,
    required this.teacherName,
  });
}
