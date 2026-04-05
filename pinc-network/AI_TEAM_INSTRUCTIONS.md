# 🤖 PINC NETWORK AI TEAM INSTRUCTIONS
## AI #5 - Research & Strategy Document

---

## 📋 PROJECT OVERVIEW

**Project Name:** PINC Network  
**Mission:** Build a comprehensive Flutter application with 6 tabs: PINC Net (VPN), Chat, Jobs, Games, Finance, Profile  
**Team Structure:**
- AI #1 (Core App Engineer): https://github.com/biosnu57-netizen/the-plat.git (branch: ai1-core)
- AI #2 (Security Engineer): Branch on kingsto (same repo as AI #5)
- AI #3 (Games Engineer): https://github.com/biosnu57-netizen/the-plat.git (branch: ai3-games)
- AI #4 (Finance Engineer): Branch on kingsto (same repo as AI #5)
- **AI #5 (Researcher - ME):** Branch: ai5-research-branch ✅

---

## 🔬 RESEARCH FINDINGS

### Best Existing Projects to Clone & Modify

#### AI #1 - CORE APP (Main 6-Tab Structure)
**Recommended Project:** `wednesday-solutions/flutter_template`
- **URL:** https://github.com/wednesday-solutions/flutter_template
- **Why:** Clean architecture, responsive design, state management, decoupled widgets
- **What to extract:** App shell, tab navigation, responsive layouts
- **Modification:** Customize to PINC's 6-tab design (PINC Net, Chat, Jobs, Games, Finance, Profile)

#### AI #2 - SECURITY (6-Phase Encryption)
**Recommended Projects:**
1. `subhashDev11/native_encryptor` - https://github.com/subhashDev11/native_encryptor
   - AES encryption with salt/IV
2. `Cipherly` - https://github.com/mtwn105/Cipherly
   - AES-256 password manager
3. `Flutter_PassVault` - https://github.com/Emon526/Flutter_PassVault
   - Multi-layer security

**What to extract:** AES-256 encryption, secure storage patterns, multi-auth layers

#### AI #3 - GAMES (6+ Games)
**Recommended Projects:**
1. **Chess:** `shenmareparas/Chess` - https://github.com/shenmareparas/Chess
   - Single/multiplayer with AI difficulty levels
2. **Tetris:** `black-purple/flutter-tetris` - https://github.com/black-purple/flutter-tetris
   - Classic Tetris gameplay
3. **Connect 4:** `davefaliskie/connect_four` - https://github.com/davefaliskie/connect_four
4. **Snake:** Search: `flutter_snake_game` on GitHub
5. **Word Game:** Search: `flutter_wordle` on GitHub
6. **Checkers:** Search: `flutter_checkers` on GitHub

**What to extract:** Game logic, UI components, league system integration points

#### AI #4 - FINANCE (Wallet & Payments)
**Recommended Projects:**
1. `mdtaosifhossain3/flutter-e-wallet-app` - https://github.com/mdtaosifhossain3/flutter-e-wallet-app
   - E-wallet with Firebase auth
2. `anilrajm/Mobile-Payment-App` - https://github.com/anilrajm/Mobile-Payment-App
   - Payment platform with wallet
3. `jameskokoska/Cashew` - https://github.com/jameskokoska/Cashew
   - Budget management with Drift SQL

**What to extract:** Wallet UI, transaction history, balance management

#### AI #1 - PINC NET (Internet Sharing)
**Recommended Project:** `WiFiFlutter` - https://github.com/flutternetwork/WiFiFlutter
- Flutter plugin suite for WiFi services
- Mesh network capabilities
- Peer-to-peer connection handling

**Special Notes for PINC Net:**
- This is NOT traditional VPN
- User in Kenya shares internet with user in Iran
- Iran's location/IP appears as Kenya's
- Kenya user can't see Iran's activity
- Uses mesh network (no central servers)
- Requires Android VPNService API for native implementation
- UI will be built now, functionality in future phase

---

## 🎯 DETAILED INSTRUCTIONS FOR EACH AI

### 🤖 AI #1: CORE APP ENGINEER

**Repository:** `pinc-core` (to be created)
**GitHub:** https://github.com/biosnu57-netizen/pinc-core

**Research Steps:**
1. Clone `wednesday-solutions/flutter_template` as base
2. Study the 6-tab structure and navigation
3. Research Flutter app architecture patterns

**What to Build:**
1. Main app shell with 6 bottom navigation tabs
2. **PINC Net Tab:**
   - Node selection UI (list of available sharers)
   - Connection status indicator
   - "Connect/Disconnect" button
   - Speed indicator
   - Location display (shows sharer's location)
3. **Chat Tab:**
   - Voice call button (microphone icon)
   - Video call button (camera icon)
   - Screen share button
   - Message input field
   - Chat history list
4. **Jobs Tab:**
   - Job marketplace UI (cards with title, price, description)
   - Search/filter functionality
   - "Apply" button on each job
5. **Profile Tab:**
   - User avatar and name
   - Settings options
   - Security settings link

**Tools to Use:**
- Flutter SDK
- Provider or Riverpod for state management
- Material Design 3 components

**Testing:**
- `flutter build apk --debug`
- Test all 6 tabs navigate correctly

**Push to:** https://github.com/biosnu57-netizen/pinc-core

---

### 🤖 AI #2: SECURITY ENGINEER

**Repository:** Branch on current repo (ai2-security)
**GitHub:** https://github.com/biosnu57-netizen/kingsto/tree/ai2-security

**Research Steps:**
1. Study `Cipherly` and `native_encryptor` for encryption patterns
2. Research AES-256 implementation in Flutter
3. Explore secure storage options (flutter_secure_storage)

**What to Build (6-Phase Security System):**
1. **Phase 1 - PIN:** 4-6 digit PIN entry
2. **Phase 2 - Password:** Strong password with validation
3. **Phase 3 - Seed Phrase:** 12/24-word backup seed
4. **Phase 4 - Private Key:** Crypto private key storage
5. **Phase 5 - Pattern:** Draw-to-unlock pattern
6. **Phase 6 - Security Questions:** 3 security questions

**Additional Features:**
- Hardware device fingerprinting
- Anti-theft protection (shutdown if SIM removed)
- Admin panel access key: `david` `orata` `anglex` `ambuch` `elderman` `makaveli`
- AES-256 encryption for all stored data

**Implementation:**
- Use `encrypt` package for AES-256
- Use `flutter_secure_storage` for sensitive data
- Use `local_auth` for biometric option

**Push to:** ai2-security branch

---

### 🤖 AI #3: GAMES ENGINEER

**Repository:** Branch on the-plat repo (ai3-games)
**GitHub:** https://github.com/biosnu57-netizen/the-plat/tree/ai3-games

**Research Steps:**
1. Clone each game repo individually
2. Study game mechanics and UI patterns
3. Research how to merge multiple games into one app

**What to Build (Minimum 6 Games):**
1. **Connect 4** - From `davefaliskie/connect_four`
2. **Tic Tac Toe** - Simple grid game
3. **Snake** - Classic snake game
4. **Tetris** - From `black-purple/flutter-tetris`
5. **Chess** - From `shenmareparas/Chess`
6. **Wordle** - Word guessing game

**Additional Features:**
- League system (up to 50 players)
- Challenge/wager system (bet PINC coins)
- External game linking UI:
  - PSN (PlayStation Network)
  - Xbox
  - Steam
- Leaderboard display

**Implementation:**
- Use `flame` game engine for complex games
- Create game selection menu
- Implement league/competition logic

**Push to:** ai3-games branch on the-plat

---

### 🤖 AI #4: FINANCE ENGINEER

**Repository:** Branch on current repo (ai4-finance)
**GitHub:** https://github.com/biosnu57-netizen/kingsto/tree/ai4-finance

**Research Steps:**
1. Clone `flutter-e-wallet-app` and study wallet patterns
2. Research payment gateway integration
3. Study escrow system implementations

**What to Build:**
1. **PINC Wallet:**
   - Balance display (large numbers)
   - Send money button
   - Receive money button
   - Transaction history
2. **Fee Calculation Service:**
   - Calculate exact transaction fees
   - Display fees before confirmation
3. **Deposit/Withdrawal UI:**
   - Bank transfer options
   - Crypto deposit option
   - Withdrawal request form
4. **Job Escrow System:**
   - Hold funds until job completed
   - Release funds on approval
   - Dispute resolution UI

**Implementation:**
- Use `provider` for state management
- Local storage for balance (Hive or SQLite)
- Mock payment processing for demo

**Push to:** ai4-finance branch

---

## 🔧 TECHNICAL GUIDELINES

### Flutter Setup
```bash
# Install Flutter if not installed
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Create project
flutter create pinc_network
cd pinc_network

# Add dependencies
flutter pub add provider flutter_secure_storage encrypt
```

### Key Dependencies
- `provider` / `flutter_riverpod` - State management
- `flutter_secure_storage` - Secure key storage
- `encrypt` - AES-256 encryption
- `hive` / `sqflite` - Local database
- `flame` - Game engine
- `permission_handler` - Handle permissions

### Code Style
- Use Clean Architecture (Data/Domain/Presentation layers)
- Follow Dart style guide
- Use meaningful variable names
- Comment complex logic

---

## 📦 REPOSITORY STRUCTURE

```
pinc-network/
├── pinc-core/          # AI #1 - Main app (new repo)
├── pinc-security/     # AI #2 - Security module (branch)
├── pinc-games/        # AI #3 - Games module (branch)
├── pinc-finance/      # AI #4 - Finance module (branch)
└── AI_TEAM_INSTRUCTIONS.md  # This document
```

---

## 🚀 NEXT STEPS

1. **Create repos:**
   - https://github.com/biosnu57-netizen/pinc-core (for AI #1)
   
2. **Each AI creates branch on their assigned repo:**
   - AI #1: ai1-core on the-plat
   - AI #2: ai2-security on kingsto
   - AI #3: ai3-games on the-plat  
   - AI #4: ai4-finance on kingsto

3. **Research & clone base projects**

4. **Implement assigned features**

5. **Test with `flutter build apk --debug`**

6. **Push to respective branches**

---

## 📝 NOTES

- PINC Net internet sharing is NOT traditional VPN - it's mesh-based sharing where user's location stays hidden but they use another user's internet
- Focus on UI/buildable code first - native VPN functionality is for future phase
- Use existing open source projects as base - don't reinvent everything
- Each AI owns their module - coordinate via PRs to main branch

---

**Document Created:** AI #5 (Researcher)  
**Branch:** ai5-research-branch  
**Status:** Research Complete - Ready for Implementation ✅