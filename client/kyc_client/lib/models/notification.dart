class UserNotification {
  int id;
  String userId;
  String title;
  String message;
  String sender;
  String date;
  bool readstatus;
  int unread;

  UserNotification({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.sender,
    this.date,
    this.readstatus,
    this.unread,
  });

  factory UserNotification.fromJson(dynamic jsonData) => UserNotification(
        id: jsonData['id'],
        userId: jsonData['userId'],
        title: jsonData['title'],
        message: jsonData['msg'],
        sender: jsonData['sender'],
        date: jsonData['date'].toString(),
        readstatus: jsonData['read status'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "sender": sender,
        "read status": readstatus,
        'date': date,
      };
}
