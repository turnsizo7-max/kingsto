# 🎓 PINC NETWORK - COMPLETE AI TEAM INSTRUCTIONS
## Professor AI #5 - Complete Development Guide

---

## 📋 TEAM ASSIGNMENTS - REPO & BRANCH MAP

| AI | Role | Repository | Branch Name | Status |
|----|------|------------|-------------|--------|
| **AI #1** | Core App Engineer | the-plat | ai1-core | 📍 START HERE |
| **AI #2** | Security Engineer | kingsto | ai2-security | 📍 START HERE |
| **AI #3** | Games Engineer | the-plat | ai3-games | 📍 START HERE |
| **AI #4** | Finance Engineer | kingsto | ai4-finance | 📍 START HERE |
| **AI #5** | Researcher (ME) | kingsto | ai5-research-branch | ✅ DONE |
| **AI #6** | Integration Engineer | the-plat | ai6-integration | 📍 START HERE |

**Repository URLs:**
- 🔗 **the-plat:** https://github.com/biosnu57-netizen/the-plat.git
- 🔗 **kingsto:** https://github.com/turnsizo7-max/kingsto.git

---

## 🔧 SETUP INSTRUCTIONS (ALL AIs MUST FOLLOW)

### Step 1: Configure Git
```bash
git config --global user.name "YourName"
git config --global user.email "your@email.com"
```

### Step 2: Clone Your Assigned Repo
```bash
# For AI #1, #3, #6 (the-plat):
git clone https://github.com/biosnu57-netizen/the-plat.git
cd the-plat

# For AI #2, #4, #5 (kingsto):
git clone https://github.com/turnsizo7-max/kingsto.git
cd kingsto
```

### Step 3: Create Your Branch
```bash
# Create and switch to your branch
git checkout -b ai1-core        # For AI #1
git checkout -b ai2-security    # For AI #2
git checkout -b ai3-games       # For AI #3
git checkout -b ai4-finance      # For AI #4
git checkout -b ai5-research     # For AI #5 (already done)
git checkout -b ai6-integration  # For AI #6
```

### Step 4: Install Flutter (if not installed)
```bash
# Check if Flutter is installed
flutter --version

# If not, install:
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:$(pwd)/flutter/bin"
flutter --version
```

---

## 🤖 AI #1: CORE APP ENGINEER
### Repo: the-plat | Branch: ai1-core

### 🎯 MISSION
Build the MAIN 6-TAB Flutter app that everyone will import their modules into.

### 📚 RESEARCH - What to Clone
Search and study these projects:
1. **App Structure:** https://github.com/wednesday-solutions/flutter_template
2. **UI Template:** https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI

### 🛠️ TOOLS TO USE
- Flutter SDK 3.41+
- `flutter_riverpod` - State management
- `hive_flutter` - Local storage
- `dio` - Networking

### 📝 WHAT TO BUILD

**1. Main.dart Structure:**
```dart
// 6 tabs bottom navigation
// Tab 1: PINC Net (VPN/Internet Sharing)
// Tab 2: Wallet (placeholder - will import AI #4)
// Tab 3: Chat (messages + call buttons)
// Tab 4: Jobs (marketplace)
// Tab 5: Games (placeholder - will import AI #3)
// Tab 6: Profile (settings)
```

**2. PINC Net Tab (Internet Sharing UI):**
- Large connect button with cyan gradient
- Node list: Kenya, Germany, USA, Japan, UK, Nigeria
- Connection status indicator
- Speed display
- IP protection status

**3. Chat Tab:**
- Message list with bubbles
- Voice call button (top bar)
- Video call button (top bar)
- Screen share button (top bar)
- FAB for new message

**4. Jobs Tab:**
- Find Jobs / My Jobs / Post Job tabs
- Job cards: Title, Budget, Deadline, Bids
- Post job form

**5. Profile Tab:**
- Avatar + PINC ID
- Language selector (20+ languages)
- Security link (to AI #2)
- Settings

**6. Wallet Tab (Placeholder):**
- Just show "Loading..." for now
- AI #4 will replace this later

**7. Games Tab (Placeholder):**
- Just show "Loading..." for now
- AI #3 will replace this later

### ✅ VERIFICATION CHECKLIST
- [ ] `flutter analyze lib/` = 0 errors
- [ ] `flutter build apk --debug` = SUCCESS
- [ ] All 6 tabs navigate correctly
- [ ] PINC Net shows node list
- [ ] Chat shows call buttons

### 📤 PUSH COMMAND
```bash
git add .
git commit -m "AI #1: Core 6-tab app structure with PINC Net, Chat, Jobs, Profile"
git push origin ai1-core
```

---

## 🤖 AI #2: SECURITY ENGINEER
### Repo: kingsto | Branch: ai2-security

### 🎯 MISSION
Build 6-phase security system, encryption, anti-theft features.

### 📚 RESEARCH - What to Clone
Search and study these projects:
1. **Encryption:** https://github.com/mtwn105/Cipherly (AES-256)
2. **Multi-layer Auth:** https://github.com/Emon526/Flutter_PassVault

### 🛠️ TOOLS TO USE
- `encrypt` package - AES encryption
- `crypto` - Hashing
- `flutter_secure_storage` - Secure key storage
- `local_auth` - Biometrics

### 📝 WHAT TO BUILD

**1. Six Phase Security (lib/security/six_phase_auth.dart):**
```dart
// Phase 1: PIN (4-6 digits)
// Phase 2: Password (with validation)
// Phase 3: Seed phrase (12/24 words)
// Phase 4: Private key storage
// Phase 5: Pattern lock (draw unlock)
// Phase 6: Security questions (3 questions)
```

**2. AES Encryption (lib/crypto/aes_encryption.dart):**
- AES-256 encryption
- Secure key storage
- Encrypt/Decrypt functions

**3. Device Fingerprint (lib/fingerprint/device_fingerprint.dart):**
- Hardware ID capture
- Device binding

**4. Anti-theft (lib/security/anti_theft.dart):**
- SIM change detection
- Shutdown protection

**5. Admin Panel (lib/security/admin_panel.dart):**
- Access keys: david, orata, anglex, ambuch, elderman, makaveli
- Admin dashboard UI

### 📁 FOLDER STRUCTURE
```
lib/
├── main.dart
├── security/
│   ├── six_phase_auth.dart
│   ├── admin_panel.dart
│   └── anti_theft.dart
├── crypto/
│   └── aes_encryption.dart
└── fingerprint/
    └── device_fingerprint.dart
```

### ✅ VERIFICATION CHECKLIST
- [ ] `flutter analyze` = 0 errors
- [ ] `flutter build apk --debug` = SUCCESS
- [ ] All 6 auth phases work
- [ ] Encryption/decryption works

### 📤 PUSH COMMAND
```bash
git checkout -b ai2-security  # Create branch if not exists
git add .
git commit -m "AI #2: 6-phase security, AES-256, anti-theft, admin panel"
git push origin ai2-security
```

---

## 🤖 AI #3: GAMES ENGINEER
### Repo: the-plat | Branch: ai3-games

### 🎯 MISSION
Build 6+ games with league system, challenge/wager system.

### 📚 RESEARCH - What to Clone
Search and clone these game repos:
1. **Chess:** https://github.com/shenmareparas/Chess
2. **Tetris:** https://github.com/black-purple/flutter-tetris
3. **Connect 4:** https://github.com/davefaliskie/connect_four

### 🛠️ TOOLS TO USE
- Flutter SDK
- `flame` game engine (for complex games)
- Custom implementations for simple games

### 📝 WHAT TO BUILD

**1. Game Selector (Main UI):**
```dart
// Grid of game icons
// Tap to launch game
// Show: Chess, Tetris, Connect 4, Snake, Wordle, Tic Tac Toe
```

**2. Games to Implement:**
1. **Chess** - From clone or custom
2. **Tetris** - From clone or custom
3. **Connect 4** - From clone or custom
4. **Snake** - Classic snake game
5. **Wordle** - Word guessing (5 letters)
6. **Tic Tac Toe** - Simple 3x3

**3. League System:**
- Leaderboard (up to 50 players)
- Player rankings
- Win/loss tracking

**4. Challenge/Wager System:**
- Challenge friend UI
- Bet PINC coins on matches
- Challenge request/accept flow

**5. External Links UI:**
- PSN (PlayStation) button
- Xbox button
- Steam button

### ✅ VERIFICATION CHECKLIST
- [ ] All 6 games playable
- [ ] League shows leaderboard
- [ ] Challenge system works
- [ ] `flutter build apk --debug` = SUCCESS

### 📤 PUSH COMMAND
```bash
git checkout -b ai3-games
git add .
git commit -m "AI #3: 6 games, league system, challenge/wager"
git push origin ai3-games
```

---

## 🤖 AI #4: FINANCE ENGINEER
### Repo: kingsto | Branch: ai4-finance

### 🎯 MISSION
Build PINC wallet, fee system, job escrow, deposits/withdrawals.

### 📚 RESEARCH - What to Clone
Search and study:
1. **Wallet UI:** https://github.com/mdtaosifhossain3/flutter-e-wallet-app
2. **Budget:** https://github.com/jameskokoska/Cashew

### 🛠️ TOOLS TO USE
- `provider` - State management
- `hive` - Local storage
- Custom fee calculation

### 📝 WHAT TO BUILD

**1. Wallet Home Screen:**
```dart
// Large balance display
// Send button
// Receive button
// Transaction history
```

**2. Send Money Screen:**
- Recipient input
- Amount input
- Note field
- Confirm button

**3. Deposit Screen:**
- Crypto (BSC) option
- PayPal option
- P2P Agent option
- Show: FREE for deposits

**4. Withdraw Screen:**
- Amount input
- Method selection (Crypto, PayPal, P2P)
- Show fee before confirm

**5. Job Escrow System:**
```dart
// Employer funds escrow (3% fee)
// Worker completes job
// Employer approves -> release to worker (9% fee)
// Or dispute resolution
```

**6. Fee Calculator (CRITICAL):**
```dart
// Internal transfer: FREE
// Withdrawal (external): 3% (or tier-based)
// Job escrow create: 3%
// Job payment: 9%
// Subscription: varies by plan
```

### ✅ VERIFICATION CHECKLIST
- [ ] Fees match EXACT specs above
- [ ] Wallet shows balance
- [ ] Escrow holds/releases funds correctly
- [ ] `flutter build apk --debug` = SUCCESS

### 📤 PUSH COMMAND
```bash
git checkout -b ai4-finance  # If on wrong branch, create new
git add .
git commit -m "AI #4: Wallet, fees, escrow, deposits, withdrawals"
git push origin ai4-finance
```

---

## 🤖 AI #6: INTEGRATION ENGINEER
### Repo: the-plat | Branch: ai6-integration

### 🎯 MISSION
Merge all AI modules together and build the final APK.

### 📚 RESEARCH
Study Flutter module imports and package structure.

### 🛠️ TOOLS TO USE
- Flutter SDK
- Package importing
- Module exports

### 📝 WHAT TO BUILD

**1. Import All Modules:**
```dart
// Import AI #2 security
import 'package:pinc_security/security.dart';

// Import AI #3 games
import 'package:pinc_games/games.dart';

// Import AI #4 finance
import 'package:pinc_finance/wallet.dart';
```

**2. Replace Placeholders:**
- Replace Wallet placeholder with AI #4's wallet
- Replace Games placeholder with AI #3's games

**3. Connect Security to Profile:**
- Link Profile tab to AI #2's security features

**4. Test Integration:**
- All modules working together
- No conflicts

### ✅ VERIFICATION CHECKLIST
- [ ] Security module integrated
- [ ] Games module integrated
- [ ] Finance module integrated
- [ ] All 6 tabs fully functional
- [ ] `flutter build apk --debug` = SUCCESS

### 📤 PUSH COMMAND
```bash
git checkout -b ai6-integration
git add .
git commit -m "AI #6: Integration of all modules - final APK ready"
git push origin ai6-integration
```

---

## 📊 WORK COMPLETION STATUS

| AI | Branch | Status | What They Built |
|----|--------|--------|------------------|
| #1 | ai1-core | ❌ NOT STARTED | Nothing |
| #2 | ai2-security | ⚠️ NEEDS FIX | Security code on main branch, need ai2-security |
| #3 | ai3-games | ❌ NOT STARTED | Nothing |
| #4 | ai4-finance | ⚠️ NEEDS FIX | Finance code on pinc-finance-dev, need ai4-finance |
| #5 | ai5-research-branch | ✅ DONE | Research, instructions, audit |
| #6 | ai6-integration | ❌ NOT STARTED | Nothing |

---

## 🔧 QUICK REFERENCE COMMANDS

```bash
# Check current branch
git branch

# Create new branch
git checkout -b branch-name

# Stage all changes
git add .

# Commit with message
git commit -m "Your message"

# Push to remote
git push origin your-branch-name

# Build APK
flutter build apk --debug

# Analyze code
flutter analyze
```

---

## 🎯 SUMMARY - WHO SHOULD DO WHAT

### AI #1 (Core - the-plat/ai1-core):
- Build 6-tab main app
- Create PINC Net, Chat, Jobs, Profile UI
- Add placeholders for Wallet & Games

### AI #2 (Security - kingsto/ai2-security):
- Fix: Move code from main to ai2-security branch
- Verify all 6 security phases work
- Create public export file

### AI #3 (Games - the-plat/ai3-games):
- Build 6 games (Chess, Tetris, Connect4, Snake, Wordle, TicTacToe)
- League system + challenges

### AI #4 (Finance - kingsto/ai4-finance):
- Fix: Rename branch to ai4-finance
- Verify fees: FREE internal, 3% withdrawal, 9% job
- Create public export

### AI #5 (Research - kingsto/ai5-research-branch):
- ✅ COMPLETE - Created all instructions

### AI #6 (Integration - the-plat/ai6-integration):
- Merge all modules
- Build final APK

---

*These instructions created by Professor AI #5*
*Each AI must follow their section exactly*
*Start with branch creation, then build, then push*