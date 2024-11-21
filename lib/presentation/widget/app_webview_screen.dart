import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:project_vehicle_log_app/support/app_theme.dart';

class AppWebViewScreen extends StatelessWidget {
  final String title;
  final String linkUrl;

  const AppWebViewScreen({
    key,
    required this.title,
    required this.linkUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: (Platform.isIOS) ? false : true,
      ),
      // android: AndroidInAppWebViewOptions(
      //   useHybridComposition: true,
      // ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Text(
                  title,
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                  style: AppTheme.theme.textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            Expanded(
              child: InAppWebView(
                initialOptions: options,
                initialUrlRequest: URLRequest(url: Uri.parse(linkUrl)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
