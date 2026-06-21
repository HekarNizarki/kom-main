import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoundScore {
  final int roundNumber;
  int? p1Points;
  int? p2Points;

  RoundScore({required this.roundNumber, this.p1Points, this.p2Points});

  Map<String, dynamic> toJson() => {
    'roundNumber': roundNumber,
    'p1Points': p1Points,
    'p2Points': p2Points,
  };

  factory RoundScore.fromJson(Map<String, dynamic> json) => RoundScore(
    roundNumber: json['roundNumber'] as int,
    p1Points: json['p1Points'] as int?,
    p2Points: json['p2Points'] as int?,
  );
}

class MatchHistoryItem {
  final String id;
  final String player1;
  final String player2;
  final int p1FinalScore;
  final int p2FinalScore;
  final DateTime date;
  final String winner;

  MatchHistoryItem({
    required this.id,
    required this.player1,
    required this.player2,
    required this.p1FinalScore,
    required this.p2FinalScore,
    required this.date,
    required this.winner,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'player1': player1,
    'player2': player2,
    'p1FinalScore': p1FinalScore,
    'p2FinalScore': p2FinalScore,
    'date': date.toIso8601String(),
    'winner': winner,
  };

  factory MatchHistoryItem.fromJson(Map<String, dynamic> json) =>
      MatchHistoryItem(
        id: json['id'] as String,
        player1: json['player1'] as String,
        player2: json['player2'] as String,
        p1FinalScore: json['p1FinalScore'] as int,
        p2FinalScore: json['p2FinalScore'] as int,
        date: DateTime.parse(json['date'] as String),
        winner: json['winner'] as String,
      );
}

class MatchState extends ChangeNotifier {
  static const String _historyKey = 'komkan_match_history';

  String _player1 = 'ALEX_V';
  String _player2 = 'JORDAN_X';
  bool _isMatchActive = false;
  int _targetScore = 30; // Max score display or goal score
  List<RoundScore> _rounds = [];
  List<MatchHistoryItem> _history = [];

  MatchState() {
    _initRounds();
    _loadHistory();
  }

  // Getters
  String get player1 => _player1;
  String get player2 => _player2;
  bool get isMatchActive => _isMatchActive;
  int get targetScore => _targetScore;
  List<RoundScore> get rounds => _rounds;
  List<MatchHistoryItem> get history => _history;

  int get p1TotalScore => _rounds.fold(0, (sum, r) {
    if (r.p1Points == null) return sum;
    if (r.p1Points == 0) return sum - 25;
    return sum + r.p1Points!;
  });

  int get p2TotalScore => _rounds.fold(0, (sum, r) {
    if (r.p2Points == null) return sum;
    if (r.p2Points == 0) return sum - 25;
    return sum + r.p2Points!;
  });

  int get currentRound {
    // Current round is the first round that doesn't have both scores entered,
    // or the last existing round if all are complete.
    for (var r in _rounds) {
      if (r.p1Points == null || r.p2Points == null) {
        return r.roundNumber;
      }
    }
    return _rounds.isNotEmpty ? _rounds.last.roundNumber : 1;
  }

  // Check who is the dealer for the current active round
  // Player 1 is dealer in odd rounds, Player 2 in even rounds
  bool get isPlayer1Dealer => currentRound % 2 != 0;

  void _initRounds() {
    _rounds = [];
  }

  bool get canAddRound {
    if (_rounds.length >= 7) return false;
    if (_rounds.isEmpty) return true;
    final last = _rounds.last;
    return last.p1Points != null && last.p2Points != null;
  }

  void addRound() {
    if (!canAddRound) return;
    final nextRoundNumber = _rounds.length + 1;
    _rounds.add(RoundScore(roundNumber: nextRoundNumber));
    notifyListeners();
  }

  // Actions
  void startMatch(String p1, String p2) {
    _player1 = p1.trim().isEmpty ? 'PLAYER 01' : p1.trim().toUpperCase();
    _player2 = p2.trim().isEmpty ? 'PLAYER 02' : p2.trim().toUpperCase();
    _isMatchActive = true;
    _initRounds();
    notifyListeners();
  }

  void updateRoundPoints(int roundIndex, {int? p1Points, int? p2Points}) {
    if (roundIndex >= 0 && roundIndex < _rounds.length) {
      if (p1Points != null) _rounds[roundIndex].p1Points = p1Points;
      if (p2Points != null) _rounds[roundIndex].p2Points = p2Points;
      notifyListeners();
    }
  }

  Future<void> endMatch() async {
    if (!_isMatchActive) return;

    final p1Final = p1TotalScore;
    final p2Final = p2TotalScore;
    String matchWinner;
    if (p1Final > p2Final) {
      matchWinner = _player1;
    } else if (p2Final > p1Final) {
      matchWinner = _player2;
    } else {
      matchWinner = 'DRAW';
    }

    final newItem = MatchHistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      player1: _player1,
      player2: _player2,
      p1FinalScore: p1Final,
      p2FinalScore: p2Final,
      date: DateTime.now(),
      winner: matchWinner,
    );

    _history.insert(0, newItem);
    _isMatchActive = false;
    _initRounds();
    notifyListeners();

    await _saveHistory();
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    await _saveHistory();
  }

  // Persistence
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyStr = prefs.getString(_historyKey);
      if (historyStr != null) {
        final List<dynamic> decoded = jsonDecode(historyStr);
        _history = decoded
            .map(
              (item) => MatchHistoryItem.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading match history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyStr = jsonEncode(
        _history.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_historyKey, historyStr);
    } catch (e) {
      debugPrint('Error saving match history: $e');
    }
  }
}
