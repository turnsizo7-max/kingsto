# PINC Games Module

🎮 AI #3: Games Engineer Implementation

## Features

### 6+ Games
- **Connect 4** - Classic column-drop game
- **Tic Tac Toe** - 3x3 grid game
- **Snake** - Classic snake game
- **Tetris** - Block-stacking puzzle
- **Chess** - Full chess board
- **Wordle** - Word guessing game

### League System
- 6 leagues: Bronze, Silver, Gold, Platinum, Diamond, Champion
- Up to 50 players per league
- Points-based ranking
- Win/loss tracking

### Challenge/Wager System
- Challenge other players
- Wager points
- Track win/loss records
- Multiple challenge statuses

### External Game Linking
- PlayStation Network (PSN)
- Xbox
- Steam

## Installation

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                   # UI Dashboard
├── games_service.dart          # Game logic
└── core/
    └── league/
        ├── league_system.dart  # Rankings & leagues
        └── challenge_system.dart # Challenges & wagers
```

## Usage

```dart
import 'lib/games_service.dart';

// Create game
final games = GamesService();
final game = games.createGame(GameType.chess, playerId);

// Join match
final match = leagueService.createMatch(...);
```

## Dependencies

- `uuid` - Unique identifiers
- `shared_preferences` - Local storage