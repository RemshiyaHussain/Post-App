import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app_with_dio/model/post_model.dart';
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
    context.read<PostBloc>().add(PostGetAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SearchBar(
              controller: searchcontroller,
              hintText: "search",
              hintStyle:
                  const WidgetStatePropertyAll(TextStyle(color: Colors.black)),
              onChanged: (value) {
                if (searchcontroller.text.trim().isEmpty) {
                  log("on changed");
                }
              },
              trailing: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.clear))
              ]),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                log(state.toString(), name: "get all post");
                if (state is PostLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PostSuccess) {
                  log("success state");
                  if (state.posts.isNotEmpty) {
                    return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(
                                  post.userid.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(post.title.toString()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.edit)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.menu_open))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  post.body.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: state.posts.length);
                  }
                }
                return Text("No post yet");
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddPost(
              post: null,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
