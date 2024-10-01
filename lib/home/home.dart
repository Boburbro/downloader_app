import 'package:downloader_app/home/files_list.dart';
import 'package:downloader_app/home/widgets/my_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => const FileLists(),
              ),
            ),
            icon: const Icon(Icons.list_rounded),
          )
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyFormField(),
            ],
          ),
        ),
      ),
    );
  }
}
