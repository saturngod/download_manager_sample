import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloaderCell extends StatefulWidget {
  final DownloadTask tasks;
  final VoidCallback refreshUI;
  final int progressVal;
  final Function(DownloadTask) onTap;
  DownloaderCell({Key? key, required this.tasks, required this.refreshUI , required this.progressVal, required this.onTap})
      : super(key: key);

  @override
  State<DownloaderCell> createState() => _DownloaderCellState();
}

class _DownloaderCellState extends State<DownloaderCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.tasks),
      child: Column(
        children: [
          Text(widget.tasks.url),
          widget.progressVal > 0 ? Text("${widget.progressVal}") : Text("${widget.tasks.progress}"),
          Row(
            children: [
              widget.tasks.status == DownloadTaskStatus.paused
                  ? IconButton(
                      onPressed: () {
                        FlutterDownloader.resume(taskId: widget.tasks.taskId);
                        widget.refreshUI();
                      },
                      icon: const Icon(Icons.play_arrow))
                  : IconButton(
                      onPressed: () {
                        FlutterDownloader.pause(taskId: widget.tasks.taskId);
                        widget.refreshUI();
                      },
                      icon: const Icon(Icons.pause)),
              IconButton(
                  onPressed: () {
                    FlutterDownloader.remove(taskId: widget.tasks.taskId);
                    widget.refreshUI();
                  },
                  icon: const Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
