import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:download_manager/pages/download_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';

class DownloaderCallBack {
  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send == null) {
      debugPrint("OH NULL >>>>> MMMMM");
    }
    send?.send([id, status, progress]);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isIOS) {
    var dir = await getApplicationSupportDirectory();
    if (!dir.existsSync()) {
      debugPrint("NOT WORKING HERE");
      // await dir.create();
    }
  }
  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterDownloader.registerCallback(DownloaderCallBack.downloadCallback);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Download Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DownloadManager(),
    );
  }
}
