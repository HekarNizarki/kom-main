import 'package:flutter/material.dart';
import 'match_state.dart';
import 'theme.dart';

class BoardScreen extends StatefulWidget {
  final MatchState matchState;
  final Function(int) onTabChange;

  const BoardScreen({
    super.key,
    required this.matchState,
    required this.onTabChange,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<TextEditingController> _p1Controllers = [];
  List<TextEditingController> _p2Controllers = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  void _syncControllers() {
    final rounds = widget.matchState.rounds;
    final currentLength = _p1Controllers.length;

    if (currentLength > rounds.length) {
      for (int i = rounds.length; i < currentLength; i++) {
        _p1Controllers[i].dispose();
        _p2Controllers[i].dispose();
      }
      _p1Controllers = _p1Controllers.sublist(0, rounds.length);
      _p2Controllers = _p2Controllers.sublist(0, rounds.length);
    } else if (currentLength < rounds.length) {
      for (int i = currentLength; i < rounds.length; i++) {
        _p1Controllers.add(
          TextEditingController(text: rounds[i].p1Points?.toString() ?? ''),
        );
        _p2Controllers.add(
          TextEditingController(text: rounds[i].p2Points?.toString() ?? ''),
        );
      }
    }

    for (int i = 0; i < rounds.length; i++) {
      final p1Text = rounds[i].p1Points?.toString() ?? '';
      if (_p1Controllers[i].text != p1Text) {
        _p1Controllers[i].text = p1Text;
      }
      final p2Text = rounds[i].p2Points?.toString() ?? '';
      if (_p2Controllers[i].text != p2Text) {
        _p2Controllers[i].text = p2Text;
      }
    }
  }

  @override
  void didUpdateWidget(covariant BoardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  @override
  void dispose() {
    for (var c in _p1Controllers) {
      c.dispose();
    }
    for (var c in _p2Controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _endMatch() async {
    final messenger = ScaffoldMessenger.of(context);
    final p1Name = widget.matchState.player1;
    final p2Name = widget.matchState.player2;
    final p1Score = widget.matchState.p1TotalScore;
    final p2Score = widget.matchState.p2TotalScore;

    await widget.matchState.endMatch();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'MATCH ENDED: $p1Name ($p1Score) vs $p2Name ($p2Score)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: KomkanTheme.accentPurple,
      ),
    );
    widget.onTabChange(2); // Go to History tab
  }

  @override
  Widget build(BuildContext context) {
    _syncControllers();
    final state = widget.matchState;

    if (!state.isMatchActive) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_esports_outlined,
              size: 64,
              color: KomkanTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'NO ACTIVE MATCH',
              style: TextStyle(
                color: KomkanTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Initialize a new session in the Setup tab.',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => widget.onTabChange(0),
              child: const Text('GO TO SETUP'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Top Player & Score Header
        _buildHeader(state),
        // Add Round Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.matchState.canAddRound
                      ? widget.matchState.addRound
                      : null,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('ADD ROUND'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KomkanTheme.primaryCyan,
                    side: const BorderSide(color: KomkanTheme.primaryCyan),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Rounds List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            itemCount: state.rounds.length,
            itemBuilder: (context, index) {
              final round = state.rounds[index];
              return _buildRoundCard(round, index);
            },
          ),
        ),
        // End Match Button Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.rounds.length == 7)
                ElevatedButton(
                  onPressed: _endMatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KomkanTheme.primaryCyan,
                    foregroundColor: const Color(0xFF0C0D12),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.flag_outlined, size: 22),
                      SizedBox(width: 8),
                      Text('END MATCH'),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10141D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KomkanTheme.border, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'ADD 7 ROUNDS TO ENABLE END MATCH',
                      style: TextStyle(
                        color: KomkanTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'AUTHENTICATED KOMKAN TOURNAMENT SCOREBOARD',
                  style: TextStyle(
                    color: KomkanTheme.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(MatchState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0C0D12),
        border: Border(bottom: BorderSide(color: KomkanTheme.border, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Total Score Banner Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: KomkanTheme.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KomkanTheme.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.player1,
                        style: const TextStyle(
                          color: KomkanTheme.primaryCyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: KomkanTheme.badgePink.withOpacity(0.15),
                          border: Border.all(
                            color: KomkanTheme.badgePink,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ROUND ${state.currentRound}/${state.rounds.length}',
                          style: const TextStyle(
                            color: KomkanTheme.badgePink,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        state.player2,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'TOTAL SCORE',
                          style: TextStyle(
                            color: KomkanTheme.primaryCyan,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${state.p1TotalScore}',
                          style: const TextStyle(
                            color: KomkanTheme.primaryCyan,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          ' / ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${state.p2TotalScore}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DIFFERENCE',
                      style: TextStyle(
                        color: KomkanTheme.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(state.p1TotalScore - state.p2TotalScore).abs()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.p1TotalScore == state.p2TotalScore
                              ? 'DRAW'
                              : state.p1TotalScore > state.p2TotalScore
                              ? state.player1
                              : state.player2,
                          style: TextStyle(
                            color: KomkanTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundCard(RoundScore round, int index) {
    final roundStr = round.roundNumber.toString().padLeft(2, '0');
    final isEditable = widget.matchState.currentRound == round.roundNumber;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: KomkanTheme.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isEditable
              ? KomkanTheme.primaryCyan.withOpacity(0.5)
              : KomkanTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Round Title Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ROUND $roundStr',
                style: TextStyle(
                  color: isEditable
                      ? KomkanTheme.primaryCyan
                      : KomkanTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.grid_view_rounded, size: 14, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 10),
          // Player points summary row
          Row(
            children: [
              Expanded(
                child: _buildPlayerPoints(
                  widget.matchState.player1,
                  _p1Controllers[index],
                  (val) {
                    final parsed = int.tryParse(val);
                    widget.matchState.updateRoundPoints(
                      index,
                      p1Points: parsed,
                    );
                  },
                  enabled: isEditable,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPlayerPoints(
                  widget.matchState.player2,
                  _p2Controllers[index],
                  (val) {
                    final parsed = int.tryParse(val);
                    widget.matchState.updateRoundPoints(
                      index,
                      p2Points: parsed,
                    );
                  },
                  enabled: isEditable,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPoints(
    String playerName,
    TextEditingController controller,
    ValueChanged<String> onChanged,
    {required bool enabled},
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          playerName,
          style: const TextStyle(
            color: KomkanTheme.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        _buildPointsField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _buildPointsField({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required bool enabled,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF090A0D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: KomkanTheme.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: enabled ? onChanged : null,
        enabled: enabled,
        readOnly: !enabled,
        showCursor: enabled,
        enableInteractiveSelection: enabled,
        keyboardType: enabled ? TextInputType.number : TextInputType.none,
        cursorColor: enabled ? KomkanTheme.primaryCyan : Colors.grey,
        style: TextStyle(
          color: enabled ? KomkanTheme.primaryCyan : Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: '-',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 2),
        ),
      ),
    );
  }
}
