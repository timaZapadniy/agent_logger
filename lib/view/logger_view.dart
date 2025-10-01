import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/logger_controller.dart';
import '../models/log.dart';
import '../repository/log_repository.dart';

class LoggerView extends StatefulWidget {
  final void Function()? onTap;

  const LoggerView({super.key, required this.onTap});

  @override
  State<LoggerView> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  late final LoggerController _controller;
  final Color _kColor = const Color(0xffbb86fc).withOpacity(0.5);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = LoggerController(LogRepository());
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
            IconButton(
              icon: const Icon(
                CupertinoIcons.arrowshape_turn_up_right_fill,
                size: 25,
              ),
              onPressed: () async {
                final result = await _controller.exportAndShare();
                if (!mounted) return;
                if (result.status == ShareResultStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logs shared successfully!')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 32),
              onPressed: widget.onTap,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _SearchField(
            onSearch: (query) => _controller.search(query),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _controller.filteredLogs.length,
              shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                final log = _controller.filteredLogs[index];
                return LogItem(
                  log: log,
                  isSelected: _controller.isSelected(log),
                  hasSelection: _controller.hasSelection,
                  onTap: () => _controller.toggleSelection(log),
                  onShare: () => _controller.shareLog(log),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Search field widget
class _SearchField extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const _SearchField({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      child: TextField(
        onChanged: onSearch,
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
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

/// Log item widget
class LogItem extends StatelessWidget {
  final Log log;
  final bool isSelected;
  final bool hasSelection;
  final VoidCallback onTap;
  final VoidCallback onShare;

  const LogItem({
    super.key,
    required this.log,
    required this.isSelected,
    required this.hasSelection,
    required this.onTap,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasSelection ? onTap : null,
      onLongPress: !hasSelection ? onTap : null,
      child: Container(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.arrowshape_turn_up_right_fill,
                  size: 18,
                  color: Colors.grey.shade300,
                ),
                onPressed: onShare,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 25,
                  minHeight: 25,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? const Color(0xffbb86fc).withOpacity(0.5)
                            : Colors.grey.shade200,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            log.message,
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (log.error != null) ...[
                            const SizedBox(height: 8),
                            SelectableText(
                              'Error: ${log.error}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (log.time != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Text(
                          DateFormat('dd:MM:yyyy – kk:mm:ss').format(log.time!),
                          style: const TextStyle(fontSize: 6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
