

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app_with_dio/model/post_model.dart';

import 'package:post_app_with_dio/presentation/bloc/post/post_state.dart';
import 'package:post_app_with_dio/repository/post_repository.dart';

part 'post_event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepositorys postRepositorys = PostRepositorys();
  PostBloc() : super(PostInitial()) {
    on<PostAddNewItem>(addNewItem);
    on<PostGetAll>(getAll);
    
  }
  void getAll(PostGetAll event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      List<PostModel> postlist =
          await postRepositorys.getAllpost(path: "posts");
          log(postlist.toString(),name:"postlist");
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
        PostModel post =
            await postRepositorys.addPost(path: "posts", post: event.post);
            log(post.toString(),name: "post");
        emit(currentsState.copyWith(
            posts: List.from(currentsState.posts)..add(post),
            isLoading: false));
      } catch (e) {
        emit(currentsState.copyWith(
            posts: List.from(currentsState.posts),
            isError: true,
            isLoading: false,
            message: e.toString()));
      }
    }
  }
   void editItem(PostEditItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        PostModel post = await postRepositorys.editPost(
            path: "post/${event.id}", post: event.post);

        emit(currentState.copyWith(
            posts: List.from(currentState.posts)
              ..removeWhere(
                (element) {
                  return element.id == event.id;
                },
              )
              ..add(post),
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

}
