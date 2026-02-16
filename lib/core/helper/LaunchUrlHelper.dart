import 'package:flutter/material.dart';
import 'package:quickseatreservation/core/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  /// Launch WhatsApp with phone number and optional message
  static Future<void> launchWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedMessage = message != null
        ? Uri.encodeComponent(message)
        : null;

    // Try native WhatsApp link first (works if WhatsApp installed)
    final nativeUri = Uri.parse(
      'whatsapp://send?phone=$cleanNumber${encodedMessage != null ? '&text=$encodedMessage' : ''}',
    );

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      // fallback to web-based wa.me link
      final webUri = Uri.parse(
        'https://wa.me/$cleanNumber${encodedMessage != null ? '?text=$encodedMessage' : ''}',
      );
      await _launchUri(webUri);
    }
  }

  /// Launch WhatsApp with phone number and optional message
  static Future<void> launchWebUrl({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // fallback to web-based wa.me link
      final webUri = Uri.parse(url);
      await _launchUri(webUri);
    }
  }

  /// Launch WhatsApp group invite link or any raw WhatsApp URL
  static Future<void> launchWhatsAppGroup(String groupLink) async {
    final uri = Uri.parse(groupLink);
    await _launchUri(uri);
  }

  /// Send email
  static Future<void> launchEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );
    await _launchUri(uri);
  }

  /// Launch Instagram profile
  static Future<void> launchInstagram(String username) async {
    final nativeUri = Uri.parse('instagram://user?username=$username');
    final webUri = Uri.parse('https://instagram.com/$username');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch Instagram post
  static Future<void> launchInstagramPost(String postId) async {
    final nativeUri = Uri.parse('instagram://media?id=$postId');
    final webUri = Uri.parse('https://instagram.com/p/$postId');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch Facebook profile
  static Future<void> launchFacebook(String profileId) async {
    final nativeUri = Uri.parse('fb://profile/$profileId');
    final webUri = Uri.parse('https://facebook.com/$profileId');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch Facebook page
  static Future<void> launchFacebookPage(String pageId) async {
    final nativeUri = Uri.parse('fb://page/$pageId');
    final webUri = Uri.parse('https://facebook.com/$pageId');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Make a phone call
  static Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launchUri(uri);
  }

  /// Send SMS
  static Future<void> sendSms({
    required String phoneNumber,
    String? message,
  }) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        if (message != null && message.isNotEmpty) 'body': message,
      },
    );
    await _launchUri(uri);
  }

  /// Open website (http/https). Automatically adds https if missing.
  static Future<void> launchWebsite(String urlString) async {
    String url = urlString;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);
    await _launchUri(uri);
  }

  /// Launch YouTube video
  static Future<void> launchYouTube(String videoId) async {
    final nativeUri = Uri.parse('vnd.youtube://$videoId');
    final webUri = Uri.parse('https://youtube.com/watch?v=$videoId');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch YouTube channel
  static Future<void> launchYouTubeChannel(String channelId) async {
    final uri = Uri.parse('https://youtube.com/channel/$channelId');
    await _launchUri(uri);
  }

  /// Launch Telegram user (opens username link)
  static Future<void> launchTelegram(String username) async {
    final uri = Uri.parse('https://t.me/$username');
    await _launchUri(uri);
  }

  /// Launch Telegram group (raw link)
  static Future<void> launchTelegramGroup(String groupLink) async {
    final uri = Uri.parse(groupLink);
    await _launchUri(uri);
  }

  /// Launch Twitter / X profile
  static Future<void> launchTwitter(String username) async {
    final nativeUri = Uri.parse('twitter://user?screen_name=$username');
    final webUri = Uri.parse('https://twitter.com/$username');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch LinkedIn profile
  static Future<void> launchLinkedIn(String profileId) async {
    final nativeUri = Uri.parse('linkedin://profile/$profileId');
    final webUri = Uri.parse('https://linkedin.com/in/$profileId');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
    } else {
      await _launchUri(webUri);
    }
  }

  /// Launch Google Maps — using lat/lng or address or placeId
  static Future<void> launchGoogleMaps({
    double? latitude,
    double? longitude,
    String? address,
    String? placeId,
  }) async {
    late Uri uri;

    if (latitude != null && longitude != null) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
    } else if (address != null && address.isNotEmpty) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    } else if (placeId != null && placeId.isNotEmpty) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=place_id:$placeId',
      );
    } else {
      throw ArgumentError('Provide latitude/longitude or address or placeId');
    }

    await _launchUri(uri);
  }

  /// Launch App Store (iOS) link
  static Future<void> launchAppStore(String appId) async {
    final uri = Uri.parse('https://apps.apple.com/app/id$appId');
    await _launchUri(uri);
  }

  /// Launch Play Store (Android) link
  static Future<void> launchPlayStore(String packageName) async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );
    await _launchUri(uri);
  }

  /// Generic method to launch any URL string
  static Future<void> launchUrlString(String urlString) async {
    final uri = Uri.parse(urlString);
    await _launchUri(uri);
  }

  /// Private helper method — unified launching with error handling
  static Future<void> _launchUri(Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Utils.showToast(
          message: 'Could not launch $uri',
          bgColor: Colors.red,
          textColor: Colors.white,
        );
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      Utils.showToast(
        message: 'Could not launch $uri: $e',
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      rethrow;
    }
  }

  static Future<void> launchZoomMeetingSimple(String meetingLink) async {
    final uri = Uri.parse(meetingLink);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Utils.showToast(
        message: 'Could not launch $uri',
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Could not launch $uri');
    }
    await _launchUri(uri);
  }
}
