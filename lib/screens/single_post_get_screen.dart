import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:session13_api/models/post_model.dart';
import 'package:http/http.dart' as http;

class SinglePostGetScreen extends StatefulWidget {
  const SinglePostGetScreen({super.key});

  @override
  State<SinglePostGetScreen> createState() => _SinglePostGetScreenState();
}

class _SinglePostGetScreenState extends State<SinglePostGetScreen> {
  Future<PostModel> getPostFromApi() async {
    try {
      String url = 'https://jsonplaceholder.typicode.com/posts/15';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        PostModel postModel = PostModel.fromJson(jsonResponse);

        await Future.delayed(const Duration(seconds: 3));
        return postModel;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      print(e.toString());

      return PostModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: const Text(
          'Get API ',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<PostModel>(
        future: getPostFromApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PostModel postModel = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('User ID ${postModel.userId}'),
                  Text('ID ${postModel.id}'),
                  Text(
                    postModel.title!,
                    style: TextStyle(fontSize: 40),
                  ),
                  Divider(),
                  Text(postModel.body!),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else {
            return const Center(
              child: SpinKitPouringHourGlass(
                color: Colors.blue,
                size: 100,
              ),
            );
          }
        },
      ),
    );
  }
}
