import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/logger_controller.dart';
import '../models/log.dart';
import '../repository/log_repository.dart';
import '../services/p2p_server.dart';
import '../widgets/connection_qr_widget.dart';

class LoggerView extends StatefulWidget {
  final void Function()? onTap;
  final P2PServer? p2pServer;

  const LoggerView({super.key, required this.onTap, this.p2pServer});

  @override
  State<LoggerView> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  late final LoggerController _controller;
  final Color _kColor = const Color(0xffbb86fc).withOpacity(0.5);
  final ScrollController _scrollController = ScrollController();
  bool _showQRCode = false;

  P2PServer? get _p2pServer =>
      kDebugMode ? (widget.p2pServer ?? P2PServer()) : null;

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

  void _toggleQRCode() {
    if (_showQRCode) {
      setState(() {
        _showQRCode = false;
      });
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ConnectionQRWidget(
          p2pServer: _p2pServer!,
          onClose: () {
            Navigator.of(context).pop();
            setState(() {
              _showQRCode = false;
            });
          },
        ),
      );
    }
  }

  void _copyServerUrl() {
    if (_p2pServer?.serverUrl != null) {
      Clipboard.setData(ClipboardData(text: _p2pServer!.serverUrl!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server URL copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Не останавливаем P2P сервер при закрытии экрана логов
    // Сервер будет работать в фоне
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
            // // QR Scanner button
            // IconButton(
            //   icon: const Icon(
            //     Icons.qr_code_scanner,
            //     size: 25,
            //   ),
            //   onPressed: _openQRScanner,
            //   tooltip: 'Scan QR Code from web browser',
            // ),
            // P2P Server status
            if (kDebugMode &&
                (_p2pServer?.isRunning == true ||
                    _p2pServer?.isConnectedToRelay == true))
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      _p2pServer!.isConnectedToRelay
                          ? Icons.cloud
                          : Icons.wifi_tethering,
                      color: _p2pServer!.isConnectedToRelay
                          ? Colors.blue
                          : Colors.green,
                      size: 25,
                    ),
                    onPressed: _toggleQRCode,
                    tooltip: _p2pServer!.isConnectedToRelay
                        ? 'Show Relay Connection QR'
                        : 'Show P2P Connection QR',
                  ),
                  if (_p2pServer!.clientsCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_p2pServer!.clientsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )
            else if (kDebugMode)
              IconButton(
                icon: const Icon(
                  Icons.wifi_off,
                  color: Colors.grey,
                  size: 25,
                ),
                onPressed: null,
                tooltip: 'P2P Server starting...',
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
          // QR Code banner (collapsible)
          if (_showQRCode &&
              kDebugMode &&
              _p2pServer?.isRunning == true &&
              _p2pServer?.serverUrl != null)
            _buildQRCodeBanner(),
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

  Widget _buildQRCodeBanner() {
    final url = _p2pServer!.serverUrl!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.green.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code, color: Colors.green),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Web Client Connection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: _toggleQRCode,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Text(
            'Enter this IP in web client:',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _copyServerUrl,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    url,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.copy, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connected clients: ${_p2pServer!.clientsCount}',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
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
