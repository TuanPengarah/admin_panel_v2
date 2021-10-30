import 'package:get/get.dart';

class GoogleSheet extends GetConnect {
  static const url =
      'https://script.google.com/macros/s/AKfycbzz50xlN5HS4A4Zf9BcYxsMJmQisPcHT-Fsu2guRUU3bMs84MnGS9p978w372K8FRS6Ig/exec';
  Future<Response> getList() => get(url);
}
