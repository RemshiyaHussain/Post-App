import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:post_app_with_dio/model/post_model.dart';
import 'package:post_app_with_dio/package/api_services.dart';

class PostRepositorys {
  Future<PostModel> addPost(
      {required String path, required PostModel post}) async {
    try {
      final Response response =
          await ApiServices.post(path: path, jsonData: post.toJson());
      log(response.toString(), name: "add post response");
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw "Something Went Wrong with response";
      }
    } catch (e) {
      throw "Something Went Wrong with request/code";
    }
  }

  Future<List<PostModel>> getAllpost({required String path}) async {
    try {
      final Response response = await ApiServices.get(path: path);
      log(response.toString(), name: "get all resoinse hre loaded");
      if (response.statusCode == 200) {
        log(response.data.toString(),name: "response data here get all");
        return (response.data as List)
            .map((postModelToJson) => PostModel.fromJson(postModelToJson))
            .toList();
      } else {
        throw "Something went wrong in response - getAllPost";
      }
    } catch (e) {
      log(e.toString(),name: "Error getAll Catchin here");
      throw "Something Went Wrong with request/code - getAllPost" ;
      
    }
  }

  Future<PostModel> editPost(
      {required String path, required PostModel post}) async {
    try {
      log(path, name: "edit post path");
      log(post.toJson().toString(), name: "post to edit");
      final Response response = await ApiServices.put(path, post.toJson());
      log(response.toString(), name: "edit post response");
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw "Wrong in response - EditPost";
      }
    } catch (e) {
      throw "Wrong with code/request -EditPost";
    }
  }
}
