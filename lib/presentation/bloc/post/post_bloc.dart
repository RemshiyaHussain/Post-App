import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app_with_dio/model/post_model.dart';

import 'package:post_app_with_dio/presentation/bloc/post/post_state.dart';
import 'package:post_app_with_dio/repository/post_repository.dart';

part 'post_event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepositorys = PostRepository();
  PostBloc() : super(PostInitial()) {
    on<PostAddNewItem>(addNewItem);
    on<PostGetAll>(getAll);
    on<PostDeleteItem>(deleteItem);
    on<PostEditItem>(editItem);
    on<PostSearchItem>(searchItem);
  }
  void getAll(PostGetAll event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      List<PostModel> postlist =
          await postRepositorys.getAllpost(path: "posts");
      log(postlist.toString(), name: "postlist");
      emit(PostSuccess(posts: postlist));
    } catch (e) {
      emit(PostError());
    }
  }

  void addNewItem(PostAddNewItem event, Emitter<PostState> emit) async {
    final currentsState = state;
    if (currentsState is PostSuccess) {
      emit(currentsState.copyWith(isLoading: true));
      try {
        await postRepositorys.addPost(path: "post", post: event.post);
        List<PostModel> updatedPosts =
            await postRepositorys.getAllpost(path: "posts");
        log(updatedPosts.toString(), name: "post list");
        emit(currentsState.copyWith(
          posts: updatedPosts,
          isLoading: false,
        ));
      } catch (e) {
        emit(currentsState.copyWith(
            isError: true, isLoading: false, message: e.toString()));
      }
    }
  }

  void editItem(PostEditItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        final post = await postRepositorys.editPost(
            path: "post/${event.id}", post: event.post);

        List<PostModel> updatedPosts =
            await postRepositorys.getAllpost(path: "posts");
        log(post.toString(), name: " updated post list");
        emit(currentState.copyWith(posts: updatedPosts, isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }

  void deleteItem(PostDeleteItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        await postRepositorys.deletePost(
          path: "post/${event.id}",
        );

        emit(currentState.copyWith(
            posts: List.from(currentState.posts)
              ..removeWhere(
                (element) {
                  return element.id == event.id;
                },
              ),
            isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }

  void searchItem(PostSearchItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        List<PostModel> postlist = await postRepositorys.searchPost(
            path: "search", searchtext: event.text);

        emit(currentState.copyWith(searchResult: postlist, isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }
}
