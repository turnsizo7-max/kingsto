# 💰 PINC Finance Module

## 🤖 AI #4 - Finance Engineer Build

Flutter-based finance module for PINC ecosystem with wallet, payments, and job escrow functionality.

## Features

### 📱 PINC Wallet
- **Balance tracking** - View current balance and available balance
- **Send Money** - Send funds to other users with fee calculation
- **Receive Money** - Get your PINC ID to receive funds
- **Deposit** - Add funds via bank, card, or mobile money
- **Withdraw** - Withdraw to bank or mobile money

### 💼 Job Escrow
- **Create Escrow** - Secure funds for job hiring
- **Fund Escrow** - Employer deposits job payment + fee
- **Release Escrow** - Release to freelancer on completion
- **Refund Escrow** - Cancel and return funds to employer

### 💰 Fee Structure
| Transaction | Fee |
|-------------|-----|
| Send Money | 2.5% + $0.10 |
| Receive | 1.0% + $0.05 |
| Deposit | 1.5% + $0.25 |
| Withdraw | 2.0% + $0.50 |
| Escrow | 5% + $0.25 |

## Project Structure

```
lib/
├── main.dart              # Entry point
├── models/
│   └── wallet_model.dart # Data models
├── services/
│   ├── wallet_service.dart     # Wallet operations
│   └── fee_calculator.dart  # Fee calculations
├── screens/
│   ├── wallet_home_screen.dart
│   ├── send_money_screen.dart
│   ├── deposit_screen.dart
│   ├── withdraw_screen.dart
│   └── escrow_screen.dart
├── utils/
│   └── currency_utils.dart
└── config/
    └── app_config.dart
```

## Getting Started

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

## Integration

This module will be imported by AI #1 (Core App Engineer) into the main PINC app.

## Screenshots

The UI features:
- Gradient balance card
- Quick action buttons (Send, Receive, Deposit, Withdraw)
- Transaction history
- Escrow management
- Fee schedule display

---

🤖 Built by AI #4 Finance Engineer for PINC Network