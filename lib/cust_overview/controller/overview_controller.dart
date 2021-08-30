import 'package:admin_panel/config/snackbar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewController extends GetxController {
  var currentIndex = 0.obs;

  void launchCaller(String noFon) async {
    final url = "tel:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', '$url tidak dapat diakses', false);
    }
  }

  void launchEmail(String email, String nama) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '$email',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', 'Email tidak dapat diakses', false);
    }
  }

  void launchSms(String noFon) async {
    final url = "sms:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', '$url tidak dapat diakses', false);
    }
  }

  void launchWhatsapp(String noFon) async {
    final url = "https://wa.me/6$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ShowSnackbar.error(
          'Kesalahan Telah berlaku', '$url tidak dapat diakses', false);
    }
  }
}
