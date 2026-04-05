import 'package:flutter/material.dart';
import '../core/security/six_phase_security.dart';
import '../core/security/anti_theft.dart';
import '../core/security/admin_panel.dart';
import '../core/fingerprint/hardware_fingerprint.dart';
import '../core/crypto/aes_encryption.dart';

void main() {
  runApp(const PincSecurityApp());
}

class PincSecurityApp extends StatelessWidget {
  const PincSecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PINC Security',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const SecurityDashboard(),
    );
  }
}

class SecurityDashboard extends StatefulWidget {
  const SecurityDashboard({super.key});

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {
  final SixPhaseSecurityService _securityService = SixPhaseSecurityService();
  final AntiTheftService _antiTheftService = AntiTheftService();
  final AdminService _adminService = AdminService();
  final HardwareFingerprintService _fingerprintService = HardwareFingerprintService();
  
  List<SecurityPhase> _phases = [];
  bool _antiTheftEnabled = false;
  DeviceFingerprint? _deviceFingerprint;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final phases = await _securityService.getPhasesStatus();
    final antiTheft = await _antiTheftService.isEnabled();
    final fp = await _fingerprintService.generateFingerprint();
    
    setState(() {
      _phases = phases;
      _antiTheftEnabled = antiTheft;
      _deviceFingerprint = fp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ PINC Security'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isAdmin ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined),
            onPressed: _showAdminDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Score Card
            _buildSecurityScoreCard(),
            const SizedBox(height: 20),
            
            // 6-Phase Security
            _buildSectionTitle('🔐 6-Phase Security'),
            const SizedBox(height: 10),
            _buildPhasesList(),
            const SizedBox(height: 20),
            
            // Device Fingerprint
            _buildSectionTitle('📱 Device Fingerprint'),
            const SizedBox(height: 10),
            _buildFingerprintCard(),
            const SizedBox(height: 20),
            
            // Anti-Theft
            _buildSectionTitle('🚨 Anti-Theft Protection'),
            const SizedBox(height: 10),
            _buildAntiTheftCard(),
            const SizedBox(height: 20),
            
            // Admin Panel (if admin)
            if (_isAdmin) ...[
              _buildSectionTitle('⚙️ Admin Panel'),
              const SizedBox(height: 10),
              _buildAdminPanel(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityScoreCard() {
    final completedPhases = _phases.where((p) => p.isCompleted).length;
    final score = (completedPhases / 6 * 100).round();
    
    Color scoreColor;
    String scoreText;
    if (score >= 80) {
      scoreColor = Colors.green;
      scoreText = 'Excellent';
    } else if (score >= 50) {
      scoreColor = Colors.orange;
      scoreText = 'Good';
    } else {
      scoreColor = Colors.red;
      scoreText = 'Weak';
    }
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: scoreColor, width: 4),
              ),
              child: Center(
                child: Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Score: $scoreText',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$completedPhases of 6 phases completed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPhasesList() {
    return Card(
      child: Column(
        children: _phases.map((phase) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: phase.isCompleted ? Colors.green : Colors.grey[300],
              child: Icon(
                phase.isCompleted ? Icons.check : Icons.lock,
                color: phase.isCompleted ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text('Phase ${phase.phaseNumber}: ${phase.name}'),
            subtitle: Text(
              phase.isCompleted ? '✅ Secured' : '⏳ Not configured',
            ),
            trailing: phase.isCompleted
                ? const Icon(Icons.verified, color: Colors.green)
                : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showPhaseDialog(phase),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFingerprintCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fingerprint, size: 40, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Device Fingerprint',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _deviceFingerprint?.deviceModel ?? 'Loading...',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_deviceFingerprint != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Device ID', _deviceFingerprint!.deviceId.substring(0, 16) + '...'),
              _buildInfoRow('Manufacturer', _deviceFingerprint!.deviceManufacturer),
              _buildInfoRow('OS Version', _deviceFingerprint!.osVersion),
              _buildInfoRow('Platform', _deviceFingerprint!.platform),
              _buildInfoRow('Physical Device', _deviceFingerprint!.isPhysicalDevice ? '✅ Yes' : '⚠️ No'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAntiTheftCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _antiTheftEnabled ? Icons.shield : Icons.shield_outlined,
                  size: 40,
                  color: _antiTheftEnabled ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Anti-Theft Protection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _antiTheftEnabled ? '✅ Enabled' : '❌ Disabled',
                        style: TextStyle(
                          color: _antiTheftEnabled ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _antiTheftEnabled,
                  onChanged: (value) => _toggleAntiTheft(value),
                ),
              ],
            ),
            if (_antiTheftEnabled) ...[
              const Divider(),
              const Text(
                'Protection Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('🔒 Shutdown Protection'),
              const Text('📱 SIM Change Detection'),
              const Text('📍 Location Tracking'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminPanel() {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  'Admin Functions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAdminButton('Unlock Account', Icons.lock_open, Colors.green),
                _buildAdminButton('Lock Account', Icons.lock, Colors.red),
                _buildAdminButton('Reset PIN', Icons.refresh, Colors.blue),
                _buildAdminButton('View Logs', Icons.history, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () => _showAdminActionDialog(label),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhaseDialog(SecurityPhase phase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Phase ${phase.phaseNumber}: ${phase.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phase.isCompleted 
                ? '✅ This phase is secured'
                : '⚠️ This phase needs to be configured',
            ),
            const SizedBox(height: 16),
            _getPhaseDescription(phase.phaseNumber),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!phase.isCompleted)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _setupPhase(phase.phaseNumber);
              },
              child: const Text('Setup'),
            ),
        ],
      ),
    );
  }

  String _getPhaseDescription(int phase) {
    switch (phase) {
      case 1:
        return 'Set up a 4-8 digit PIN as your first line of defense.';
      case 2:
        return 'Create a strong password (8+ characters) for additional security.';
      case 3:
        return 'Secure your wallet with a 12-24 word seed phrase.';
      case 4:
        return 'Import or generate a 256-bit private key for crypto operations.';
      case 5:
        return 'Draw a pattern (4+ dots) as an alternative unlock method.';
      case 6:
        return 'Set up 3 security questions for account recovery.';
      default:
        return '';
    }
  }

  void _setupPhase(int phase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Setup Phase $phase'),
        content: TextField(
          decoration: InputDecoration(
            labelText: _getPhaseInputLabel(phase),
            hintText: _getPhaseInputHint(phase),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completePhase(phase);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _getPhaseInputLabel(int phase) {
    switch (phase) {
      case 1: return 'Enter PIN';
      case 2: return 'Enter Password';
      case 3: return 'Enter Seed Phrase';
      case 4: return 'Enter Private Key';
      case 5: return 'Draw Pattern';
      case 6: return 'Security Questions';
      default: return 'Value';
    }
  }

  String _getPhaseInputHint(int phase) {
    switch (phase) {
      case 1: return '4-8 digits';
      case 2: return '8+ characters';
      case 3: return '12-24 words';
      case 4: return '64 character hex key';
      case 5: return '4+ dots';
      case 6: return 'Question/Answer pairs';
      default: return 'Value';
    }
  }

  Future<void> _completePhase(int phase) async {
    await _securityService.completePhase(phase);
    await _loadStatus();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phase $phase completed!')),
      );
    }
  }

  Future<void> _toggleAntiTheft(bool value) async {
    if (value) {
      await _antiTheftService.enableAntiTheft(
        shutdownProtection: true,
        simChangeDetection: true,
      );
    } else {
      await _antiTheftService.disableAntiTheft();
    }
    await _loadStatus();
  }

  void _showAdminDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Authentication'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Admin Key',
            hintText: 'Enter admin key',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await _adminService.authenticate(controller.text);
              Navigator.pop(context);
              setState(() {
                _isAdmin = success;
              });
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Admin access granted!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid admin key')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showAdminActionDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$action completed!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}