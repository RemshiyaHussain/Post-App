// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

sealed class PostEvent {}

class PostGetAll extends PostEvent {}

class PostAddNewItem extends PostEvent {
  final PostModel post;
  PostAddNewItem({
    required this.post,
  });
}

class PostEditItem extends PostEvent {
  final PostModel post;
  final int id;
  PostEditItem({
    required this.post,
    required this.id,
  });
}

class PostDeleteItem extends PostEvent {
  final int id;
  PostDeleteItem({required this.id});
}

class PostSearchItem extends PostEvent {
  final String text;
  PostSearchItem({required this.text});
}
