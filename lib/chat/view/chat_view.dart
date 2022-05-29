import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/chat/controller/chat_controller.dart';
import 'package:admin_panel/chat/model/chat_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatView extends GetView<ChatController> {
  final _data = Get.arguments;
  final _params = Get.parameters;
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_data['name']),
        toolbarHeight: 80,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Pilihan',
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Buang semua perbualan'),
                        leading: Icon(Icons.clear),
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: Text('Amaran'),
                              content: Text(
                                  'Adakan anda pasti untuk membuang semua perbualan?'),
                              actions: [
                                TextButton(
                                  onPressed: () => controller.deletedChat(),
                                  child: Text(
                                    'Buang',
                                    style: TextStyle(color: Colors.amber[900]),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Haptic.feedbackError();
                                    Get.back();
                                  },
                                  child: Text('Batal'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Segar semula'),
                        leading: Icon(Icons.refresh),
                        onTap: () => controller.refreshChat(),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Get.theme.canvasColor,
        ),
        child: ClipRRect(
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<ChatController>(builder: (context) {
                  return FutureBuilder(
                      future: controller.chatList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return controller.chat.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_outlined,
                                        size: 160,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Tiada perbualan ditemui!',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 20),
                                itemCount: controller.chat.length,
                                itemBuilder: (context, i) {
                                  var chat = controller.chat[i];
                                  String date =
                                      DateFormat('dd-MM-yyyy • hh:mm a')
                                          .format(DateTime.parse(chat.date))
                                          .toString();
                                  return AnimationConfiguration.staggeredList(
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                          child: FadeInAnimation(
                                              child: _chat(chat, date))));
                                },
                              );
                      });
                }),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: controller.typing,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Tulis sesuatu...',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Ink(
                          child: InkWell(
                            onTap: () {
                              ChatModel chitChat = ChatModel(
                                idUser: _params['id'],
                                content: controller.typing.text,
                                date: DateTime.now().toString(),
                                whoChat: 0,
                              );
                              controller.sendChat(chitChat);
                              Haptic.feedbackSuccess();
                            },
                            child: CircleAvatar(
                              backgroundColor: Get.theme.primaryColor,
                              radius: 30,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chat(ChatModel chat, String date) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          chat.whoChat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        chat.whoChat == 0
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_data['photoURL']),
                ),
              ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          width: Get.width / 1.8,
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Colors.blueGrey.shade800
                : Colors.blue.shade100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: chat.whoChat == 0
                  ? Radius.circular((20))
                  : Radius.circular(0),
              bottomRight: chat.whoChat == 1
                  ? Radius.circular((20))
                  : Radius.circular(0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: chat.whoChat == 0
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                chat.whoChat == 0
                    ? _authController.userName.value
                    : _data['name'].toString(),
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 10,
                ),
              ),
              SelectableText(
                chat.content.toString(),
              ),
              SizedBox(height: 10),
              Text(
                '$date',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
        chat.whoChat == 1
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: ExtendedNetworkImageProvider(
                      _data['photoURL1'],
                      cache: true),
                ),
              ),
      ],
    );
  }
}
