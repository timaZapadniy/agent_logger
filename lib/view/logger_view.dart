import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../buffer_output.dart';
import '../models/log.dart';

List<Log> selectedLogs = [];

class LoggerView extends StatefulWidget {
  final void Function()? onTap;
  LoggerView({super.key, required this.onTap});

  @override
  State<LoggerView> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  List<Log> _logList = BufferOutput().lines.reversed.toList();

  final Color _kColor = const Color(0xffbb86fc).withOpacity(0.5);

  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    selectedLogs = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _kColor,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                "AgentLogger",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  String filee = await _write(BufferOutput().lines.toList());
                  final result =
                      await Share.shareXFiles([XFile(filee)], text: 'Logs');

                  if (result.status == ShareResultStatus.success) {
                    print('Thank you for sharing the picture!');
                  }
                },
                child: const Icon(
                  CupertinoIcons.arrowshape_turn_up_right_fill,
                  size: 25,
                  weight: 5,
                )),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
                onTap: widget.onTap,
                child: const Icon(
                  Icons.close,
                  size: 32,
                  weight: 10,
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            child: TextField(
              onSubmitted: (value) {
                _logList = BufferOutput()
                    .lines
                    .reversed
                    .toList()
                    .where((element) => element.message.contains(value))
                    .toList();
                setState(() {
                  print(selectedLogs);
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _logList.length,
              shrinkWrap: true,
              reverse: true,
              controller: _controller,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return LogItem(log: _logList[index]);
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class LogItem extends StatefulWidget {
  const LogItem({
    super.key,
    required this.log,
  });

  final Log log;

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedLogs.isNotEmpty) {
          _isSelected
              ? selectedLogs.remove(widget.log)
              : selectedLogs.add(widget.log);
          setState(() {
            _isSelected = !_isSelected;
          });
        }
      },
      onLongPress: () {
        if (selectedLogs.isEmpty) {
          _isSelected
              ? selectedLogs.remove(widget.log)
              : selectedLogs.add(widget.log);
          setState(() {
            _isSelected = !_isSelected;
          });
        }
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  height: 25,
                  width: 25,
                  child: GestureDetector(
                      onTap: () {
                        Share.share(
                            '${DateFormat('dd:MM:yyyy – kk:mm:ss').format(widget.log.time!)}\n${widget.log.message}',
                            subject: '');
                      },
                      child: Icon(
                        CupertinoIcons.arrowshape_turn_up_right_fill,
                        size: 18,
                        weight: 5,
                        color: Colors.grey.shade300,
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _isSelected
                          ? Color(0xffbb86fc).withOpacity(0.5)
                          : (Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.log.message,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.log.time != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(
                    DateFormat('dd:MM:yyyy – kk:mm:ss')
                        .format(widget.log.time!),
                    style: const TextStyle(fontSize: 6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String> _write(List<Log> logList) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String fileName =
      'log_${DateFormat('dd:MM:yyyy – kk:mm:ss').format(DateTime.now())}.txt';
  final File file = File('${directory.path}/$fileName');
  String text = '';
  logList.forEach((element) {
    text =
        '$text \n\n (${DateFormat('dd:MM:yyyy – kk:mm:ss').format(element.time!)}) ${element.message}';
  });

  await file.writeAsString(text);
  return '${directory.path}/$fileName';
}
