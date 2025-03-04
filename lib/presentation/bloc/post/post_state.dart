import 'package:equatable/equatable.dart';
import 'package:post_app_with_dio/model/post_model.dart';

class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final List<PostModel> posts;
  final bool isError;
  final String message;
  final bool isLoading;
  final List<PostModel> searchResult;

  const PostSuccess({
    required this.posts,
    this.searchResult = const [],
    this.isError = false,
    this.message = "",
    this.isLoading = false,
  });
  @override
  List<Object> get props => [posts, isError, searchResult, message, isLoading];

  PostSuccess copyWith({
    List<PostModel>? posts,
    List<PostModel>? searchResult,
    bool? isError,
    String? message,
    bool? isLoading,
  }) {
    return PostSuccess(
      posts: posts ?? this.posts,
      searchResult: searchResult ?? this.searchResult,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class PostError extends PostState {}
