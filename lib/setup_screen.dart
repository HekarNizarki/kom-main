import 'package:flutter/material.dart';
import 'match_state.dart';
import 'theme.dart';

class SetupScreen extends StatefulWidget {
  final MatchState matchState;
  final Function(int) onTabChange;

  const SetupScreen({
    super.key,
    required this.matchState,
    required this.onTabChange,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _p1Controller = TextEditingController();
  final TextEditingController _p2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _p1Controller.text = widget.matchState.player1;
    _p2Controller.text = widget.matchState.player2;
  }

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    super.dispose();
  }

  void _startMatch() {
    widget.matchState.startMatch(
      _p1Controller.text,
      _p2Controller.text,
    );
    // Switch to Scoreboard tab
    widget.onTabChange(1);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          // Session Initialization Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: KomkanTheme.primaryCyan.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(4),
                color: KomkanTheme.primaryCyan.withOpacity(0.05),
              ),
              child: const Text(
                'SESSION INITIALIZATION',
                style: TextStyle(
                  color: KomkanTheme.primaryCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Title Heading
          Center(
            child: Text(
              'PREPARE FOR\nENGAGEMENT',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    shadows: [
                      Shadow(
                        color: KomkanTheme.primaryCyan.withOpacity(0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
            ),
          ),
          const SizedBox(height: 40),
          // Player 1 Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KomkanTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KomkanTheme.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'PLAYER 01',
                      style: TextStyle(
                        color: KomkanTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(
                      Icons.person_outline,
                      color: KomkanTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _p1Controller,
                  style: const TextStyle(
                    color: KomkanTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ENTER CODENAME',
                    filled: false,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Player 2 Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KomkanTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KomkanTheme.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'PLAYER 02',
                      style: TextStyle(
                        color: KomkanTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(
                      Icons.person_add_alt_1_outlined,
                      color: KomkanTheme.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _p2Controller,
                  style: const TextStyle(
                    color: KomkanTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ENTER CODENAME',
                    filled: false,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10141D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1B2332), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: KomkanTheme.primaryCyan,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'MATCH DATA WILL BE RECORDED TO GLOBAL ANALYTICS. ENSURE BOTH PLAYERS ARE READY BEFORE INITIALIZING SEQUENCE.',
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Start Match Button
          ElevatedButton(
            onPressed: _startMatch,
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shadowColor: KomkanTheme.primaryCyan.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.play_arrow, size: 24),
                SizedBox(width: 8),
                Text('START MATCH'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
