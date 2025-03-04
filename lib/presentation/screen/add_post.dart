import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app_with_dio/model/post_model.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_bloc.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_state.dart';

class AddPost extends StatefulWidget {
  final PostModel? post;
  const AddPost({
    super.key,
    this.post,
  });

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController userNameController;
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    if (widget.post != null) {
      titleController = TextEditingController(text: widget.post?.title ?? "");
      bodyController = TextEditingController(text: widget.post?.body ?? "");
      userNameController =
          TextEditingController(text: widget.post?.userName ?? "");
    } else {
      titleController = TextEditingController();
      bodyController = TextEditingController();
      userNameController = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("UserName"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the user name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Title"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: bodyController,
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          label: Text("body"),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the body";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<PostBloc, PostState>(
                          listener: (context, state) {
                        if (state is PostSuccess) {
                          if (state.isError) {
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      }, builder: (context, state) {
                        log(state.toString(), name: "state");
                        return ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (!(state is PostSuccess && state.isLoading)) {
                                if (formkey.currentState!.validate()) {
                                  final title = titleController.text.trim();
                                  final userName =
                                      userNameController.text.trim();
                                  final body = bodyController.text.trim();

                                  final post = PostModel(
                                    id: widget.post?.id ?? 0,
                                    title: title,
                                    body: body,
                                    userName: userName,
                                  );
                                  log(post.toString(), name: "add post");
                                  if (widget.post == null) {
                                    context
                                        .read<PostBloc>()
                                        .add(PostAddNewItem(post: post));
                                  } else {
                                    context.read<PostBloc>().add(
                                        PostEditItem(post: post, id: post.id));
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: state is PostSuccess && state.isLoading
                                ? CircularProgressIndicator()
                                :widget.post!= null?
                                const Text("edit")
                                : const Text("Save"));
                      }),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
