import 'package:flutter/material.dart';
import 'match_state.dart';
import 'theme.dart';
import 'setup_screen.dart';
import 'board_screen.dart';
import 'history_screen.dart';

void main() {
  runApp(const KomkanApp());
}

class KomkanApp extends StatelessWidget {
  const KomkanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Komkan Scoreboard',
      theme: KomkanTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MatchState _matchState = MatchState();
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _matchState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _matchState.removeListener(_onStateChange);
    _matchState.dispose();
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  void _onTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KomkanTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'KOMKAN OPTIONS',
                    style: TextStyle(
                      color: KomkanTheme.primaryCyan,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'About Komkan',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: const Text(
                    'Futuristic tournament scorekeeper',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'KOMKAN',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.sports_esports,
                        color: KomkanTheme.primaryCyan,
                        size: 32,
                      ),
                      children: const [
                        Text(
                          'An elegant scorekeeper app for card games, board games, and Esports matches.',
                        ),
                      ],
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.history_outlined,
                    color: KomkanTheme.primaryCyan,
                  ),
                  title: const Text(
                    'Match History',
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: const Text(
                    'Open archived matches',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _onTabChange(2);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                    color: KomkanTheme.badgePink,
                  ),
                  title: const Text(
                    'Clear Match Records',
                    style: TextStyle(color: KomkanTheme.badgePink),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmClearHistory();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KomkanTheme.cardBackground,
        title: const Text(
          'CLEAR HISTORY',
          style: TextStyle(
            color: KomkanTheme.badgePink,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Delete all match archives? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'CLEAR ALL',
              style: TextStyle(color: KomkanTheme.badgePink),
            ),
            onPressed: () {
              _matchState.clearHistory();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(
              Icons.sports_esports_outlined,
              color: KomkanTheme.primaryCyan,
              size: 26,
            ),
            SizedBox(width: 8),
            Text(
              'KOMKAN',
              style: TextStyle(
                color: KomkanTheme.primaryCyan,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add_alt_1_outlined,
              color: _currentTab == 0
                  ? KomkanTheme.primaryCyan
                  : KomkanTheme.textSecondary,
            ),
            tooltip: 'Setup',
            onPressed: () => _onTabChange(0),
          ),
          IconButton(
            icon: Icon(
              Icons.scoreboard_outlined,
              color: _currentTab == 1
                  ? KomkanTheme.primaryCyan
                  : KomkanTheme.textSecondary,
            ),
            tooltip: _matchState.isMatchActive ? 'Score' : 'Board',
            onPressed: () => _onTabChange(1),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: KomkanTheme.textSecondary,
            ),
            onPressed: _openSettings,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: KomkanTheme.border, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentTab,
          children: [
            SetupScreen(matchState: _matchState, onTabChange: _onTabChange),
            BoardScreen(matchState: _matchState, onTabChange: _onTabChange),
            HistoryScreen(matchState: _matchState),
          ],
        ),
      ),
    );
  }
}
