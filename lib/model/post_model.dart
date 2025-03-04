import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends Equatable {
  int id;
  String title;
  String body;
  String userName;
  PostModel({
    required this.id,
    required this.userName,
    required this.title,
    required this.body,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
  @override
  List<Object?> get props => [
        id,
        userName,
        title,
        body,
      ];
}
