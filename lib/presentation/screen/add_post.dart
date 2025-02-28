import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_app_with_dio/model/post_model.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_bloc.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_state.dart';
import 'package:post_app_with_dio/presentation/screen/home_screen.dart';

class AddPost extends StatefulWidget {
  final PostModel? post;
  const AddPost({super.key, this.post});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController useridController;
  late TextEditingController titleController;
  late TextEditingController bodyController;
  final ImagePicker imagepick = ImagePicker();
  File? imagefile;
  selectFile() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (file != null) {
      setState(() {
        imagefile = File(file.path);
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      titleController = TextEditingController(text: widget.post!.title);
      bodyController = TextEditingController(text: widget.post!.body);
      useridController =
          TextEditingController(text: widget.post!.userid.toString());
    } else {
      titleController = TextEditingController();
      bodyController = TextEditingController();
      useridController = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    useridController.dispose();
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
                      controller: useridController,
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
                    // if (imagefile != null)
                    //   Expanded(
                    //     child: Image.file(
                    //       File(imagefile!.path),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // TextButton(
                    //     onPressed: () async {
                    //       await selectFile();
                    //     },
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Container(
                    //           margin: EdgeInsets.only(top: 5),
                    //           child: Icon(Icons.image),
                    //         ),
                    //         Container(
                    //           padding: EdgeInsets.only(top: 4, left: 10),
                    //           child: Text("Add Image"),
                    //         )
                    //       ],
                    //     )),
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
                           Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                          if (!(state is PostSuccess && state.isLoading)) {
                            if (formkey.currentState!.validate()) {
                              final title = titleController.text.trim();
                              final body = bodyController.text.trim();
                              final userId = useridController.text.trim();
                              final post = PostModel(
                                  id: widget.post != null
                                      ? widget.post!.id!
                                      : 0,
                                  title: title,
                                  body: body,
                                  userid: userId);
                              log(post.toString(), name: "add data");

                              context
                                  .read<PostBloc>()
                                  .add(PostAddNewItem(post: post));
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: state is PostSuccess && state.isLoading
                              ? CircularProgressIndicator()
                              : widget.post != null
                                  ? const Text("Edit")
                                  : const Text("Save"),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
