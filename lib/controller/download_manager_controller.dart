

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:path_provider/path_provider.dart';

class DownloadManagerController extends GetxController {
  RxList<DownloadTask> tasks = <DownloadTask>[].obs;

  RxMap<String,int> progressTasks = <String,int>{}.obs;
  
  
  
  @override
  void onInit() {
    reload();
    super.onInit();
  }


  void addNewProgress(String id,int progress) {
    Map<String,int> oldValue = {};
      for(String key in progressTasks.keys) {
        if(progressTasks[key] != null) {
          oldValue[key] = progressTasks[key]!;
        }
      }
      oldValue[id] = progress;
      
      progressTasks.value = oldValue;
  }
  void addUrl(String url) async {
    
    var path = "";

    if(Platform.isAndroid) {
      //flutter downloader only support the getExternalStorageDirectory for Android now.
      final baseStorage = await getExternalStorageDirectory();
      if(baseStorage == null) {
        return;
      }
      path = baseStorage.path;  
    }
    else if(Platform.isIOS) {
      //flutter downloader only support the getApplicationDocumentsDirectory for iOS now.
      final baseStorage = await getApplicationDocumentsDirectory();
      path = baseStorage.path;  
    }
    else {
      debugPrint("Not supported platform");
      return;
    }
    
    debugPrint(path);
    DateTime now = DateTime.now();
    var newTaskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: path,
        allowCellular: true,
        fileName: 'Sample${now.millisecondsSinceEpoch}.mp4');

    debugPrint("NEW TAKS ID IS $newTaskId");

    var newTasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task where task_id = '$newTaskId'");

    debugPrint("${newTasks?.length}");

    if (newTasks != null && newTasks.isNotEmpty) {
      tasks.add(newTasks.first);
    }
  }

  Future<void> reload() async {
    var loaded = await FlutterDownloader.loadTasks();

    if (loaded != null) {
      debugPrint("${loaded.length}");
      tasks.clear();
      tasks.addAll(loaded);
    } else {
      debugPrint("NO TASKS");
      tasks.clear();
    }
    
  }
}
