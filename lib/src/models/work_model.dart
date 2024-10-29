class WorkModel {
  String taskID;
  String userID;
  String createdDate;
  String status;
  double rate;
  String updatedDate;
  String file;
  String fileType;
  double? fileSize;
  String text;

  WorkModel({
    required this.fileSize,
    required this.createdDate,
    required this.updatedDate,
    required this.fileType,
    required this.file,
    required this.userID,
    required this.text,
    required this.status,
    required this.taskID,
    required this.rate,
});
}