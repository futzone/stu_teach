class TaskModel {
  String title;
  String id;
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
    this.id = '',
    required this.teacherName,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'file': file,
        'fileSize': fileSize,
        'fileType': fileType,
        'createdDate': createdDate.toIso8601String(),
        'updatedDate': updatedDate.toIso8601String(),
        'deadlineDate': deadlineDate.toIso8601String(),
        'teacherName': teacherName,
        'teacherId': teacherId,
        'id': id ?? ''
      };

  factory TaskModel.fromJson(dynamic json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'],
      description: json['description'],
      file: json['file'],
      fileSize: (json['fileSize'] as num?)?.toDouble(),
      fileType: json['fileType'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      deadlineDate: DateTime.parse(json['deadlineDate']),
      teacherName: json['teacherName'],
      teacherId: json['teacherId'],
    );
  }
}
