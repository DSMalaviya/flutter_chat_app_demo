// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final String from;
  final String to;
  final String time;
  final String content;
  final int type;

  ChatModel({
    required this.from,
    required this.to,
    required this.time,
    required this.content,
    required this.type,
  });

  ChatModel copyWith({
    String? from,
    String? to,
    String? time,
    String? content,
    int? type,
  }) {
    return ChatModel(
      from: from ?? this.from,
      to: to ?? this.to,
      time: time ?? this.time,
      content: content ?? this.content,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'time': time,
      'content': content,
      'type': type,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      from: map['from'] as String,
      to: map['to'] as String,
      time: map['time'] as String,
      content: map['content'] as String,
      type: map['type'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(from: $from, to: $to, time: $time, content: $content, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.from == from &&
        other.to == to &&
        other.time == time &&
        other.content == content &&
        other.type == type;
  }

  @override
  int get hashCode {
    return from.hashCode ^
        to.hashCode ^
        time.hashCode ^
        content.hashCode ^
        type.hashCode;
  }
}
