import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

class FileLists extends StatelessWidget {
  const FileLists({super.key});

  Future<List<String>> getFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    List<String> fileNames = [];
    for (var i in directory.listSync()) {
      fileNames.add(i.path.split(directory.path).last);
    }
    return fileNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("List"),
      ),
      body: FutureBuilder(
        future: getFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data![index]),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
