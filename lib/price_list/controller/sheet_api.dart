import 'package:get/get.dart';

class GoogleSheet extends GetConnect {
  static const urlGetList =
      'https://script.google.com/macros/s/AKfycbzz50xlN5HS4A4Zf9BcYxsMJmQisPcHT-Fsu2guRUU3bMs84MnGS9p978w372K8FRS6Ig/exec';
  static const urlAddList =
      'https://script.google.com/macros/s/AKfycbzNDsjqKifz-I8WUKbdTF3pnTX41XBzDzrK8EdZ4yTkS7Shz9IW8koSl0N5eUUqWfO7Cg/exec';

  static const STATUS_SUCCESS = 'SUCCESS';
  static const STATUS_FAILURE = 'FAILURE';

  Future<Response> getList() => get(urlGetList);

  Future<Response> addList(String params) => get(urlAddList + params);
}
