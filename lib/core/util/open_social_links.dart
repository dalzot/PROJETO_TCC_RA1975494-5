import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/core/util/print_exception.dart';

import '../theme/app_color.dart';
import 'global_functions.dart';
import 'global_launch_url.dart';

class OpenSocialLink {
  sendWhatsMessage(String targetPhone, {String message = ""}) async {
    String whatsAppUrl = 'https://api.whatsapp.com/send?phone=55$targetPhone';
    if (message.isNotEmpty) {
      String messageUrl = '&text=$message';
      whatsAppUrl += messageUrl;
    }

    Uri fullMessage = Uri.parse(whatsAppUrl);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullMessage);
    } catch (e) {
      snackBar('Falha ao abrir Whatsapp', color: appNormalDangerColor);
    }
  }

  sendTelegramMessage(String targetUser) async {
    String url = 'https://t.me/$targetUser';
    Uri fullMessage = Uri.parse(url);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullMessage);
    } catch (e) {
      snackBar('Falha ao abrir Telegram', color: appNormalDangerColor);
    }
  }

  sendInstagram(String targetUser) async {
    String url = 'https://www.instagram.com/$targetUser';
    Uri fullMessage = Uri.parse(url);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullMessage);
    } catch (e) {
      snackBar('Falha ao abrir Instagram', color: appNormalDangerColor);
    }
  }

  sendFacebook(String targetUser) async {
    String url = 'https://www.facebook.com/$targetUser';
    Uri fullMessage = Uri.parse(url);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullMessage);
    } catch (e) {
      snackBar('Falha ao abrir Facebook', color: appNormalDangerColor);
    }
  }

  sendLinkedin(String targetUser) async {
    String url = 'https://www.linkedin.com/in/$targetUser';
    Uri fullMessage = Uri.parse(url);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullMessage);
    } catch (e) {
      snackBar('Falha ao abrir Linkedin', color: appNormalDangerColor);
    }
  }

  openGoogleMaps(String address) async {
    String url = 'https://www.google.com.br/maps/search/${address.replaceAll(' ', '+')}';
    Uri fullUrl = Uri.parse(url);
    try {
      await GlobalLaunchUrlFunction().launchURL(fullUrl);
    } catch (e,st) {
      printException('openGoogleMaps', e, st);
      snackBar('Falha ao abrir Linkedin', color: appNormalDangerColor);
    }
  }

  callTo(String targetPhone) async {
    try {
      await GlobalLaunchUrlFunction().launch(Uri.parse('calto:$targetPhone'));
    } catch (e) {
      snackBar('Falha ao iniciar chamada', color: appNormalDangerColor);
    }
  }
}