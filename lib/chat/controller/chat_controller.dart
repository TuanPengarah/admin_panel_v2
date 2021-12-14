import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/chat/model/chat_model.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<ChatModel> chat = [];
  TextEditingController typing = TextEditingController();
  Future chatList;
  final _params = Get.parameters;

  @override
  void onInit() {
    chatList = getChat(_params['id']);
    super.onInit();
  }

  void sendChat(ChatModel chitChat) async {
    if (typing.text.isNotEmpty) {
      await DatabaseHelper.instance.addChat(chitChat);
      typing.clear();
      await getChat(chitChat.idUser);
    }
  }

  Future<void> getChat(String idUser) async {
    chat = [];
    var chatList = await DatabaseHelper.instance.getChat(idUser);
    chat = chatList;
    chat.sort((b, a) => a.id.compareTo(b.id));
    update();
  }

  void deletedChat() {
    chat.forEach((element) {
      DatabaseHelper.instance.deletedChat(element.id);
    });
    chat.clear();
    Get.back();
    Get.back();
    Haptic.feedbackSuccess();
    update();
  }

  Future<void> refreshChat() async {
    Haptic.feedbackClick();
    await getChat(_params['id']);
    Get.back();
  }

  void chatMockup() {
    /// 0 kita chat
    /// 1 orang tu chat
    ChatModel chitChat1 = ChatModel(
        id: 0,
        content: 'Assalamualaikum',
        date: DateTime.now().toString(),
        whoChat: 0);
    ChatModel chitChat2 = ChatModel(
        id: 1,
        content: 'Waalaikumussalam',
        date: DateTime.now().toString(),
        whoChat: 1);
    ChatModel chitChat3 = ChatModel(
        id: 2,
        content:
            'Tahniah team semalam buat sales hampir 20k nanti hujung bulan ni kita pergi bercuti nak? nanti kita bincang nak bercuti dekat mana... Luar atau dalam negara tak kisah hehe!',
        date: DateTime.now().toString(),
        whoChat: 0);

    chat.add(chitChat1);
    chat.add(chitChat2);
    chat.add(chitChat3);

    chat.sort((b, a) => a.id.compareTo(b.id));
  }
}
