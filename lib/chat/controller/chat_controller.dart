import 'package:admin_panel/API/notif_fcm.dart';
import 'package:admin_panel/auth/controller/firebase_auth_controller.dart';
import 'package:admin_panel/chat/model/chat_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/home/controller/home_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<ChatModel> chat = [];
  TextEditingController typing = TextEditingController();
  Future? chatList;
  final _params = Get.parameters;
  final _data = Get.arguments;
  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();
  var chatStream = FirebaseMessaging.onMessage;
  @override
  void onClose() {
    chatStream
        .listen(streamChat)
        .cancel()
        .then((value) => debugPrint('stream closed'));
    _homeController.isChat = false;
    super.onClose();
  }

  @override
  void onInit() {
    _homeController.isChat = true;
    // streamChat();
    chatStream.listen(streamChat);
    chatList = getChat(_params['id'].toString());
    super.onInit();
  }

  void streamChat(RemoteMessage message) {
    // chatStream.listen((message) {
    if (message.data['screen'] == '/chat' && _homeController.isChat == true) {
      debugPrint('incoming message');
      getChat(_params['id'].toString());
    }

    // });
  }

  void sendChat(ChatModel chitChat) async {
    if (typing.text.isNotEmpty) {
      // await DatabaseHelper.instance.addChat(chitChat);
      typing.clear();
      await getChat(chitChat.idUser.toString());
      debugPrint('sending to token: ${_data['token']}');
      await NotifFCM()
          .postData(
            'Mesej dari ${_authController.userName.value}',
            chitChat.content,
            isChat: true,
            token: _data['token'],
            userToken: _authController.token,
            uid: _authController.userUID.value,
            name: _authController.userName.value,
            photoURL: _data['photoURL'],
            photoURL1: _data['photoURL1'],
          )
          .then((value) => debugPrint(value.statusText.toString()));
    }
  }

  Future<void> getChat(String idUser) async {
    chat = [];
    // var chatList = await DatabaseHelper.instance.getChat(idUser);
    // chat = chatList;
    // chat.sort((b, a) => a.id!.compareTo(b.id));
    update();
  }

  void deletedChat() {
    // chat.forEach((element) {
    //   DatabaseHelper.instance.deletedChat(element.id);
    // });
    chat.clear();
    Get.back();
    Get.back();
    Haptic.feedbackSuccess();
    update();
  }

  Future<void> refreshChat() async {
    Haptic.feedbackClick();
    await getChat(_params['id'].toString());
    Get.back();
  }

  // void chatMockup() {
  //   /// 0 kita chat
  //   /// 1 orang tu chat
  //   ChatModel chitChat1 = ChatModel(
  //       id: 0,
  //       content: 'Assalamualaikum',
  //       date: DateTime.now().toString(),
  //       whoChat: 0);
  //   ChatModel chitChat2 = ChatModel(
  //       id: 1,
  //       content: 'Waalaikumussalam',
  //       date: DateTime.now().toString(),
  //       whoChat: 1);
  //   ChatModel chitChat3 = ChatModel(
  //       id: 2,
  //       content:
  //           'Tahniah team semalam buat sales hampir 20k nanti hujung bulan ni kita pergi bercuti nak? nanti kita bincang nak bercuti dekat mana... Luar atau dalam negara tak kisah hehe!',
  //       date: DateTime.now().toString(),
  //       whoChat: 0);

  //   chat.add(chitChat1);
  //   chat.add(chitChat2);
  //   chat.add(chitChat3);

  //   chat.sort((b, a) => a.id.compareTo(b.id));
  // }
}
