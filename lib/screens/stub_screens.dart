// Stub screens to fix compilation - simplified versions
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Simplified deposit screen
class DepositScreen extends StatefulWidget {
  final Function(double amount, String method) onDeposit;
  const DepositScreen({super.key, required this.onDeposit});
  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text) ?? 0;
              widget.onDeposit(amount, 'bank');
            },
            child: const Text('Deposit'),
          ),
        ]),
      ),
    );
  }
}

// Simplified withdraw screen
class WithdrawScreen extends StatefulWidget {
  final double availableBalance;
  final Function(double amount, String method) onWithdraw;
  const WithdrawScreen({super.key, required this.availableBalance, required this.onWithdraw});
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('Available: \$${widget.availableBalance}'),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text) ?? 0;
              widget.onWithdraw(amount, 'bank');
            },
            child: const Text('Withdraw'),
          ),
        ]),
      ),
    );
  }
}

// Simplified escrow screen
class EscrowScreen extends StatelessWidget {
  final double availableBalance;
  final List escrows;
  final Function onCreateEscrow;
  final Function onFund;
  final Function onRelease;
  final Function onRefund;
  const EscrowScreen({
    super.key,
    required this.availableBalance,
    required this.escrows,
    required this.onCreateEscrow,
    required this.onFund,
    required this.onRelease,
    required this.onRefund,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escrow')),
      body: const Center(child: Text('Escrow System')),
    );
  }
}

// Simplified send money screen
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _recipientController,
            decoration: const InputDecoration(labelText: 'Recipient PINC ID'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Send'),
          ),
        ]),
      ),
    );
  }
}

// Simple wallet home screen
class WalletHomeScreen extends StatelessWidget {
  const WalletHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
        SizedBox(height: 16),
        Text('PINC Wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Balance: 1000.00 PINC', style: TextStyle(fontSize: 18, color: Colors.green)),
      ])),
    );
  }
}
