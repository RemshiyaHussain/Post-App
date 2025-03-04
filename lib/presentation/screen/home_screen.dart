import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:post_app_with_dio/presentation/bloc/post/post_bloc.dart';
import 'package:post_app_with_dio/presentation/bloc/post/post_state.dart';

import 'package:post_app_with_dio/presentation/screen/add_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchcontroller = TextEditingController();

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<PostBloc>().add(PostGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchBar(
                controller: searchcontroller,
                hintText: "search",
                hintStyle: const WidgetStatePropertyAll(
                    TextStyle(color: Colors.black)),
                onChanged: (value) {
                  if (searchcontroller.text.trim().isNotEmpty) {
                    log("on changed");
                    context
                        .read<PostBloc>()
                        .add(PostSearchItem(text: searchcontroller.text));
                  }
                },
                trailing: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // context
                        //     .read<PostBloc>()
                        //     .add(PostSearchItem(text: searchcontroller.text));
                      },
                      icon: Icon(Icons.search)),
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        searchcontroller.clear();
                      },
                      icon: Icon(Icons.clear))
                ]),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child:
                  BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                log(state.toString(), name: "get all post");
                if (state is PostLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PostSuccess) {
                  log("success state");
                  final posts = searchcontroller.text.trim().isEmpty
                      ? state.posts
                      : state.searchResult;
                  if (posts.isEmpty) {
                    return Center(child: Text("No posts found"));
                  }
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(
                                  post.userName.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return AddPost(
                                              post: post,
                                            );
                                          }));
                                        },
                                        icon: Icon(Icons.edit)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          context
                                              .read<PostBloc>()
                                              .add(PostDeleteItem(id: post.id));
                                          context
                                              .read<PostBloc>()
                                              .add(PostGetAll());
                                        },
                                        style: IconButton.styleFrom(
                                          foregroundColor: Colors.black,
                                        ),
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  post.title.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  post.body.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: posts.length);
                }

                return const Text("No Post Yet");
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPost()),
          );

          if (result == true) {
            context.read<PostBloc>().add(PostGetAll());
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
