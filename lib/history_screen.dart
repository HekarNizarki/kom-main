import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'match_state.dart';
import 'theme.dart';

class HistoryScreen extends StatelessWidget {
  final MatchState matchState;

  const HistoryScreen({
    super.key,
    required this.matchState,
  });

  void _clearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: KomkanTheme.cardBackground,
          title: const Text(
            'CLEAR HISTORY',
            style: TextStyle(
              color: KomkanTheme.badgePink,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete all saved match records? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: const Text('CLEAR ALL', style: TextStyle(color: KomkanTheme.badgePink)),
              onPressed: () {
                matchState.clearHistory();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Match history cleared.'),
                    backgroundColor: KomkanTheme.badgePink,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = matchState.history;

    return Column(
      children: [
        // Subheader row with title and clear button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF0C0D12),
            border: Border(
              bottom: BorderSide(color: KomkanTheme.border, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MATCH ARCHIVES',
                style: TextStyle(
                  color: KomkanTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              if (history.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: KomkanTheme.badgePink),
                  tooltip: 'Clear History',
                  onPressed: () => _clearHistory(context),
                ),
            ],
          ),
        ),
        // History List
        Expanded(
          child: history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off_outlined,
                        size: 64,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'NO MATCHES RECORDED',
                        style: TextStyle(
                          color: KomkanTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete a match to store stats here.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _buildHistoryCard(context, item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, MatchHistoryItem item) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = dateFormat.format(item.date);

    final isP1Winner = item.winner == item.player1;
    final isP2Winner = item.winner == item.player2;
    final isDraw = item.winner == 'DRAW';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KomkanTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KomkanTheme.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date & ID row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2028),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ID: ${item.id.substring(item.id.length - 5)}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 9,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Scores & Player names
          Row(
            children: [
              // Player 1 Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.player1,
                      style: TextStyle(
                        color: isP1Winner ? KomkanTheme.primaryCyan : Colors.white70,
                        fontWeight: isP1Winner ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.p1FinalScore} PTS',
                      style: TextStyle(
                        color: isP1Winner ? KomkanTheme.primaryCyan : Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // VS Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              // Player 2 Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.player2,
                      style: TextStyle(
                        color: isP2Winner ? KomkanTheme.primaryCyan : Colors.white70,
                        fontWeight: isP2Winner ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.p2FinalScore} PTS',
                      style: TextStyle(
                        color: isP2Winner ? KomkanTheme.primaryCyan : Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            color: KomkanTheme.border,
          ),
          const SizedBox(height: 12),
          // Winner Announcement Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STATUS',
                style: TextStyle(
                  color: KomkanTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDraw
                      ? Colors.grey[900]
                      : KomkanTheme.primaryCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDraw ? Colors.grey[700]! : KomkanTheme.primaryCyan,
                    width: 1,
                  ),
                ),
                child: Text(
                  isDraw ? 'DRAW' : 'WINNER: ${item.winner}',
                  style: TextStyle(
                    color: isDraw ? Colors.grey : KomkanTheme.primaryCyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
