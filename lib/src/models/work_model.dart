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
    required this.taskID,
    required this.userID,
    required this.createdDate,
    required this.status,
    required this.rate,
    required this.updatedDate,
    required this.file,
    required this.fileType,
    this.fileSize,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'taskID': taskID,
        'userID': userID,
        'createdDate': createdDate,
        'status': status,
        'rate': rate,
        'updatedDate': updatedDate,
        'file': file,
        'fileType': fileType,
        'fileSize': fileSize,
        'text': text,
      };

  factory WorkModel.fromJson(dynamic json) {
    return WorkModel(
      taskID: json['taskID'],
      userID: json['userID'],
      createdDate: json['createdDate'],
      status: json['status'],
      rate: (json['rate'] as num).toDouble(),
      updatedDate: json['updatedDate'],
      file: json['file'],
      fileType: json['fileType'],
      fileSize: (json['fileSize'] as num?)?.toDouble(),
      text: json['text'],
    );
  }
}
