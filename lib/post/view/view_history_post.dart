import 'dart:io';

import 'package:admin_panel/post/model/history_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controller/controller_create_post.dart';

class ViewHistoryPost extends StatefulWidget {
  const ViewHistoryPost({super.key});

  @override
  State<ViewHistoryPost> createState() => _ViewHistoryPostState();
}

class _ViewHistoryPostState extends State<ViewHistoryPost> {
  final _controller = Get.find<ControllerCreatePost>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sejarah Post'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('historyPost'),
        builder: (context, AsyncSnapshot<Box> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 10),
                  Text('Memuatkan data...')
                ],
              ),
            );
          }

          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, i) {
                var box = Hive.box('historyPost');
                var sejarah = HistoryPost.fromLocalDB(box.values.toList()[i]);
                var keys = box.keys.toList();
                return ListTile(
                  title: Text(sejarah.model),
                  subtitle: Text(sejarah.repair),
                  leading: CircleAvatar(
                    backgroundImage: FileImage(
                      File(sejarah.path),
                    ),
                  ),
                  onTap: () => _controller.pickHistory(sejarah),
                  onLongPress: () {
                    setState(() {
                      box.delete(keys[i]);
                    });
                  },
                );
              },
            );
          } else if (snapshot.data!.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Tiada sejarah post ditemui!'),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
