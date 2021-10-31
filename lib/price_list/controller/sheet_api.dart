import 'package:get/get.dart';

class GoogleSheet extends GetConnect {
  static const urlGetList =
      'https://script.google.com/macros/s/AKfycbxLe-qSaNh52R79FKx3t0msD-AQpuI8g7PX4QPyasFhizwfjh_RyqCfV8Y2sEktaal8hg/exec';
  static const urlAddList =
      'https://script.google.com/macros/s/AKfycbwB8xSfQYdA5RGZ5EY-xVaHgsSVUDi4yMCIQlZXBrFZX1nkGCDFgtfRoP2q8ggnnJ3tEA/exec';
  //
  // static const urlDeleteList =
  //     'https://script.google.com/macros/s/AKfycbxAWFSoKzFKkPR5QLFwx9U5f1rKGl8X5T8RpT61CWYXGAZq7YABvZW0SCC2tx3PEPgzcQ/exec';

  static const STATUS_SUCCESS = 'SUCCESS';
  static const STATUS_FAILURE = 'FAILURE';

  Future<Response> getList() => get(urlGetList);

  Future<Response> addList(String params) => get(urlAddList + params);

  // Future<Response> deleteList(String params) => get(urlDeleteList + params);
}
