import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'User.dart';

class Message with EquatableMixin {
  final User user;
  final int? msgType;
  final String? title;
  final String? body;

  Message({
    required this.user,
    this.msgType,
    this.title,
    this.body
  });

  @override
  List<Object?> get props => [
    user,
    msgType,
    title,
    body
  ];

  factory Message.fromRawJson(String str) =>
      Message.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Message.fromMap(Map<String, dynamic> json) => Message(
    user: User.fromMap(json['user']),
    msgType: json['msg_type'],
    title: json['title'],
    body: json['body'],
  );

  Map<String, dynamic> toMap() => {
    'user': user.toRawJson(),
    'msg_type': msgType,
    'title': title,
    'body': body,
  };
}