import 'dart:isolate';
import 'dart:ui';

import 'package:download_manager/view/downloader_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/download_manager_controller.dart';

class DownloadManager extends StatefulWidget {
  DownloadManager({Key? key}) : super(key: key);

  @override
  State<DownloadManager> createState() => _DownloadManagerState();
}

class _DownloadManagerState extends State<DownloadManager> {
  var controller = Get.put(DownloadManagerController());

  @override
  void initState() {
    Permission.storage.request();
    super.initState();

    initDownloader();
  }

  final ReceivePort _port = ReceivePort();
  void initDownloader() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      //DownloadTaskStatus status = data[1];
      int progress = data[2];
      controller.addNewProgress(id, progress);

      debugPrint("PROGRESS >>>>>> $progress");
      debugPrint("TASKS ID IS $id");
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Download Manager"),
          actions: [
            IconButton(
                onPressed: () {
                  controller.addUrl(
                      "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4");
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  controller.reload();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Obx(() {
          print(controller.progressTasks.toString());
          return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: ((context, index) {
                debugPrint(controller.tasks[index].taskId + " <<<<< TAKSID");
                return DownloaderCell(
                  tasks: controller.tasks[index],
                  progressVal: controller
                          .progressTasks[controller.tasks[index].taskId] ??
                      0,
                  onTap: (task) =>
                      Get.snackbar("File", task.filename ?? "NO FILE"),
                  refreshUI: () async {
                    await controller.reload();
                    setState(() {});
                  },
                );
              }));
        }));
  }
}
