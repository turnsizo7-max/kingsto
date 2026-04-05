import 'package:flutter/material.dart';
import 'games_service.dart';
import 'core/league/league_system.dart';
import 'core/league/challenge_system.dart';

void main() {
  runApp(const PincGamesApp());
}

class PincGamesApp extends StatelessWidget {
  const PincGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🎮 PINC Games',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const GamesDashboard(),
    );
  }
}

class GamesDashboard extends StatefulWidget {
  const GamesDashboard({super.key});

  @override
  State<GamesDashboard> createState() => _GamesDashboardState();
}

class _GamesDashboardState extends State<GamesDashboard> {
  final GamesService _gamesService = GamesService();
  final LeagueService _leagueService = LeagueService();
  final ChallengeService _challengeService = ChallengeService();
  
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 PINC Games'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: [
        _buildGamesGrid(),
        _buildLeaderboard(),
        _buildChallenges(),
        _buildExternalLinks(),
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_esports), label: 'Games'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leagues'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Challenges'),
          NavigationDestination(icon: Icon(Icons.link), label: 'External'),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    final games = [
      {'name': 'Connect 4', 'icon': Icons.grid_on, 'color': Colors.red},
      {'name': 'Tic Tac Toe', 'icon': Icons.close, 'color': Colors.blue},
      {'name': 'Snake', 'icon': Icons.pest_control, 'color': Colors.green},
      {'name': 'Tetris', 'icon': Icons.view_module, 'color': Colors.orange},
      {'name': 'Chess', 'icon': Icons.account_balance, 'color': Colors.brown},
      {'name': 'Wordle', 'icon': Icons.abc, 'color': Colors.purple},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Card(
          color: (game['color'] as Color).withOpacity(0.2),
          child: InkWell(
            onTap: () => _showGameDialog(game['name'] as String),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(game['icon'] as IconData, size: 48, color: game['color'] as Color),
                const SizedBox(height: 8),
                Text(game['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaderboard() {
    final stats = _leagueService.getLeagueStats();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏆 League Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...stats.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      _getLeagueIcon(e.key),
                      const SizedBox(width: 8),
                      Text(e.key),
                      const Spacer(),
                      Text('${e.value} players', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('👑 Top Players', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildTopPlayer(1, 'ChampionX', 'Diamond', 1500),
                _buildTopPlayer(2, 'GameMaster', 'Gold', 980),
                _buildTopPlayer(3, 'ProGamer', 'Silver', 650),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopPlayer(int rank, String name, String league, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rank == 1 ? Colors.amber : rank == 2 ? Colors.grey[400] : Colors.brown[300],
            ),
            child: Center(child: Text('#$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: _getLeagueColor(league), borderRadius: BorderRadius.circular(12)),
            child: Text(league, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Text('$points pts', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildChallenges() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text('Create New Challenge'),
            subtitle: const Text('Challenge another player'),
            onTap: () => _showCreateChallengeDialog(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('🎯 Active Challenges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _buildChallengeItem('Player1', 'Connect 4', 100, 'pending'),
              _buildChallengeItem('Player2', 'Chess', 250, 'accepted'),
              _buildChallengeItem('Player3', 'Tic Tac Toe', 50, 'completed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeItem(String opponent, String game, int wager, String status) {
    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'accepted': statusColor = Colors.green; statusIcon = Icons.play_arrow; break;
      case 'completed': statusColor = Colors.blue; statusIcon = Icons.check; break;
      default: statusColor = Colors.orange; statusIcon = Icons.hourglass_empty;
    }
    
    return ListTile(
      leading: CircleAvatar(backgroundColor: statusColor.withOpacity(0.2), child: Icon(statusIcon, color: statusColor)),
      title: Text('vs $opponent'),
      subtitle: Text('$game • ${wager}P wager'),
      trailing: Chip(label: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10))),
    );
  }

  Widget _buildExternalLinks() {
    final links = [
      {'platform': 'PSN', 'username': 'GamerTag123', 'icon': Icons.gamepad},
      {'platform': 'Xbox', 'username': 'XboxPlayer', 'icon': Icons.sports_esports},
      {'platform': 'Steam', 'username': 'SteamUser', 'icon': Icons.computer},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.add_link, color: Colors.purple),
            title: const Text('Link New Account'),
            subtitle: const Text('Connect PSN, Xbox, or Steam'),
            onTap: () => _showLinkAccountDialog(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('🔗 Connected Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...links.map((link) => Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.purple.withOpacity(0.2), child: Icon(link['icon'] as IconData, color: Colors.purple)),
            title: Text(link['platform'] as String),
            subtitle: Text(link['username'] as String),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ),
        )),
      ],
    );
  }

  Widget _getLeagueIcon(String league) {
    switch (league) {
      case 'Champion': return const Icon(Icons.emoji_events, color: Colors.amber);
      case 'Diamond': return const Icon(Icons.diamond, color: Colors.blue);
      case 'Platinum': return const Icon(Icons.star, color: Colors.grey);
      case 'Gold': return const Icon(Icons.star, color: Colors.amber);
      case 'Silver': return const Icon(Icons.star, color: Colors.grey[400]);
      default: return const Icon(Icons.star, color: Colors.brown);
    }
  }

  Color _getLeagueColor(String league) {
    switch (league) {
      case 'Champion': return Colors.amber;
      case 'Diamond': return Colors.blue;
      case 'Platinum': return Colors.grey;
      case 'Gold': return Colors.amber;
      case 'Silver': return Colors.grey[400]!;
      default: return Colors.brown;
    }
  }

  void _showGameDialog(String gameName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🎮 $gameName'),
        content: const Text('Game lobby - Waiting for opponent...'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Find Match')),
        ],
      ),
    );
  }

  void _showCreateChallengeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Challenge'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Select Opponent')),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Wager Points')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(items: const [
              DropdownMenuItem(value: 'connect4', child: Text('Connect 4')),
              DropdownMenuItem(value: 'chess', child: Text('Chess')),
            ], onChanged: (v) {}),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Send Challenge')),
        ],
      ),
    );
  }

  void _showLinkAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link External Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(items: const [
              DropdownMenuItem(value: 'psn', child: Text('PlayStation Network')),
              DropdownMenuItem(value: 'xbox', child: Text('Xbox')),
              DropdownMenuItem(value: 'steam', child: Text('Steam')),
            ], onChanged: (v) {}),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: 'Username')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Link')),
        ],
      ),
    );
  }
}