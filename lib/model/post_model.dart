import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_model.g.dart';

@JsonSerializable()

// ignore: must_be_immutable
class PostModel extends Equatable {
  int? id;
  String? userid;
  String? title;
  String? body;
  PostModel({this.id, this.userid, this.title, this.body});
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
  @override
  List<Object?> get props => [id, userid, title, body];
}
