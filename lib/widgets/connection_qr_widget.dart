import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../services/p2p_server.dart';

/// Widget for displaying connection QR code in mobile app
class ConnectionQRWidget extends StatelessWidget {
  final P2PServer p2pServer;
  final VoidCallback? onClose;

  const ConnectionQRWidget({
    super.key,
    required this.p2pServer,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Connect Web Client',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            p2pServer.isConnectedToRelay
                ? 'Scan QR code with web client to connect via relay server'
                : 'Scan QR code with web client to connect directly',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: QrImageView(
              data: _getConnectionData(),
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              errorStateBuilder: (context, error) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[400],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QR Error',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Connection info
          _buildConnectionInfo(theme),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyConnectionData(context),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy URL'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareConnectionData(context),
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Close button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onClose,
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          if (p2pServer.isConnectedToRelay) ...[
            _buildInfoRow('Relay Server', p2pServer.relayServerUrl ?? 'Unknown',
                Icons.cloud),
            if (p2pServer.sessionId != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Session ID', p2pServer.sessionId!, Icons.key),
            ],
            if (p2pServer.deviceId != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                  'Device ID', p2pServer.deviceId!, Icons.phone_android),
            ],
          ] else ...[
            _buildInfoRow(
                'Server URL', p2pServer.serverUrl ?? 'Not running', Icons.wifi),
            _buildInfoRow('Clients', '${p2pServer.clientsCount}', Icons.people),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getConnectionData() {
    if (p2pServer.isConnectedToRelay) {
      // For relay server, return the web client connection URL
      final serverUrl = p2pServer.relayServerUrl;
      final sessionId = p2pServer.sessionId;
      if (serverUrl != null && sessionId != null) {
        final uri = Uri.parse(serverUrl);
        final protocol = uri.scheme == 'https' ? 'wss' : 'ws';
        return '$protocol://${uri.host}:${uri.port}/ws?type=web&session=$sessionId';
      }
    } else {
      // For direct P2P, return the mobile server URL
      final serverUrl = p2pServer.serverUrl;
      if (serverUrl != null) {
        final uri = Uri.parse(serverUrl);
        final protocol = uri.scheme == 'https' ? 'wss' : 'ws';
        return '$protocol://${uri.host}:${uri.port}/ws';
      }
    }
    return 'ws://localhost:8080/ws';
  }

  void _copyConnectionData(BuildContext context) {
    final data = _getConnectionData();
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection URL copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareConnectionData(BuildContext context) {
    final data = _getConnectionData();
    Share.share(
      'Connect to Agent Logger:\n$data',
      subject: 'Agent Logger Connection',
    );
  }
}
