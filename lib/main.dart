/// PINC Finance Module - Main Entry Point
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/wallet_model.dart';
import 'services/wallet_service.dart';
import 'screens/wallet_home_screen.dart';
import 'screens/send_money_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/escrow_screen.dart';

void main() {
  runApp(const PincFinanceApp());
}

class PincFinanceApp extends StatelessWidget {
  const PincFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletController()..init('user_123'),
      child: MaterialApp(
        title: 'PINC Finance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const FinanceHomeScreen(),
      ),
    );
  }
}

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({super.key});

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _WalletTab(),
          _EscrowTab(),
          _HistoryTab(),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.assured_workload), label: 'Escrow'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _WalletTab extends StatelessWidget {
  const _WalletTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletController>(
      builder: (context, controller, _) {
        final wallet = controller.wallet;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('💰 PINC Wallet'),
            centerTitle: true,
          ),
          body: WalletHomeScreen(
            balance: wallet?.balance ?? 0,
            availableBalance: wallet?.availableBalance ?? 0,
            transactionCount: controller.transactions.length,
            onSendMoney: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SendMoneyScreen(
                  availableBalance: wallet?.availableBalance ?? 0,
                  onSend: controller.sendMoney,
                ),
              ),
            ),
            onReceiveMoney: () => _showReceiveDialog(context),
            onDeposit: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DepositScreen(onDeposit: controller.deposit),
              ),
            ),
            onWithdraw: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WithdrawScreen(
                  availableBalance: wallet?.availableBalance ?? 0,
                  onWithdraw: controller.withdraw,
                ),
              ),
            ),
            onViewHistory: () {},
          ),
        );
      },
    );
  }

  void _showReceiveDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Receive Money',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Share your PINC ID to receive money:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'user_123',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EscrowTab extends StatelessWidget {
  const _EscrowTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletController>(
      builder: (context, controller, _) {
        final wallet = controller.wallet;
        
        return EscrowScreen(
          availableBalance: wallet?.availableBalance ?? 0,
          escrows: controller.escrows,
          onCreateEscrow: controller.createEscrow,
          onFund: controller.fundEscrow,
          onRelease: controller.releaseEscrow,
          onRefund: controller.refundEscrow,
        );
      },
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Consumer<WalletController>(
        builder: (context, controller, _) {
          if (controller.transactions.isEmpty) {
            return const Center(
              child: Text('No transactions yet'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final tx = controller.transactions[index];
              final isCredit = tx.type == TransactionType.receive || 
                             tx.type == TransactionType.deposit;
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (isCredit ? Colors.green : Colors.red).withOpacity(0.1),
                  child: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(tx.type.name.toUpperCase()),
                subtitle: Text(tx.description ?? ''),
                trailing: Text(
                  '${isCredit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Fee Schedule'),
            onTap: () => _showFeeSchedule(context),
          ),
        ],
      ),
    );
  }

  void _showFeeSchedule(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💰 PINC Fee Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Send Money: 2.5% + \$0.10'),
            Text('Receive Money: 1.0% + \$0.05'),
            Text('Deposit: 1.5% + \$0.25'),
            Text('Withdrawal: 3% + \$0.50'),
            Text('Escrow: 9% + \$0.25'),
            SizedBox(height: 16),
            Text('Minimum send fee: \$0.50'),
            Text('Minimum escrow fee: \$1.00'),
          ],
        ),
      ),
    );
  }
}

class WalletController extends ChangeNotifier {
  final WalletService _service = WalletService();
  WalletModel? _wallet;
  
  WalletController() : super();

  WalletModel? get wallet => _wallet;
  List<TransactionModel> get transactions => _service.getTransactions();
  List<EscrowModel> get escrows => _service.getEscrows();

  Future<void> init(String userId) async {
    _wallet = await _service.initWallet(userId);
    notifyListeners();
  }

  Future<void> deposit(double amount, String method) async {
    await _service.deposit(amount: amount, method: method);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> withdraw(double amount, String method) async {
    await _service.withdraw(amount: amount, method: method);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> sendMoney(double amount, String recipientId, String? note) async {
    await _service.sendMoney(amount: amount, recipientId: recipientId, description: note);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> createEscrow(String jobId, String freelancerId, double amount) async {
    await _service.createEscrow(jobId: jobId, freelancerId: freelancerId, amount: amount);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> fundEscrow(String escrowId) async {
    await _service.fundEscrow(escrowId);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> releaseEscrow(String escrowId) async {
    await _service.releaseEscrow(escrowId);
    _wallet = _service.currentWallet;
    notifyListeners();
  }

  Future<void> refundEscrow(String escrowId) async {
    await _service.refundEscrow(escrowId);
    _wallet = _service.currentWallet;
    notifyListeners();
  }
}