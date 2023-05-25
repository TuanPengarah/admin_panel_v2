class ChatModel {
  final int? id;
  final String? idUser;
  final String content;
  final String date;
  final int whoChat;

  ChatModel({
    this.id,
    this.idUser,
    required this.content,
    required this.date,
    required this.whoChat,
  });

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
        id: json['id'],
        idUser: json['idUser'],
        content: json['content'].toString(),
        date: json['date'].toString(),
        whoChat: json['whoChat'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'idUser': idUser,
        'content': content,
        'date': date,
        'whoChat': whoChat,
      };
}
