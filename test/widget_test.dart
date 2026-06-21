import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kom/main.dart';
import 'package:kom/match_state.dart';

void main() {
  // Mock SharedPreferences
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('MatchState Unit Tests', () {
    test('Initialization checks', () {
      final state = MatchState();
      expect(state.player1, 'ALEX_V');
      expect(state.player2, 'JORDAN_X');
      expect(state.isMatchActive, false);
      expect(state.rounds.length, 7);
      expect(state.p1TotalScore, 0);
      expect(state.p2TotalScore, 0);
    });

    test('Start match action updates state', () {
      final state = MatchState();
      state.startMatch('Player A', 'Player B');
      expect(state.player1, 'PLAYER A');
      expect(state.player2, 'PLAYER B');
      expect(state.isMatchActive, true);
      expect(state.currentRound, 1);
    });

    test('Score recording updates total score', () {
      final state = MatchState();
      state.startMatch('Player A', 'Player B');

      // Round 1
      state.updateRoundPoints(0, p1Points: 12, p2Points: 8);
      expect(state.p1TotalScore, 12);
      expect(state.p2TotalScore, 8);
      expect(state.currentRound, 2);

      // Round 2
      state.updateRoundPoints(1, p1Points: 15, p2Points: 22);
      expect(state.p1TotalScore, 27);
      expect(state.p2TotalScore, 30);
    });

    test('Deducts 25 points if a player scores 0 in a round', () {
      final state = MatchState();
      state.startMatch('Player A', 'Player B');

      // Round 1: P1 scores 0, P2 scores 10
      state.updateRoundPoints(0, p1Points: 0, p2Points: 10);
      expect(state.p1TotalScore, -25);
      expect(state.p2TotalScore, 10);

      // Round 2: P1 scores 15, P2 scores 0
      state.updateRoundPoints(1, p1Points: 15, p2Points: 0);
      expect(state.p1TotalScore, -10); // -25 + 15 = -10
      expect(state.p2TotalScore, -15); // 10 - 25 = -15
    });

    test('Deal count modifications work', () {
      final state = MatchState();
      state.startMatch('Player A', 'Player B');

      state.updateRoundDeals(0, isPlayer1: true, delta: 1);
      state.updateRoundDeals(0, isPlayer1: false, delta: 2);

      expect(state.rounds[0].p1Deals, 1);
      expect(state.rounds[0].p2Deals, 2);

      state.updateRoundDeals(0, isPlayer1: true, delta: -1);
      expect(state.rounds[0].p1Deals, 0);
    });

    test('Ending a match saves history item', () async {
      final state = MatchState();
      state.startMatch('Alex', 'Jordan');
      state.updateRoundPoints(0, p1Points: 20, p2Points: 10);
      await state.endMatch();

      expect(state.isMatchActive, false);
      expect(state.history.length, 1);
      expect(state.history[0].player1, 'ALEX');
      expect(state.history[0].player2, 'JORDAN');
      expect(state.history[0].winner, 'ALEX');
    });
  });

  group('UI Integration Tests', () {
    testWidgets('App renders Setup tab by default', (WidgetTester tester) async {
      await tester.pumpWidget(const KomkanApp());
      await tester.pumpAndSettle();

      // Find "SESSION INITIALIZATION" badge
      expect(find.text('SESSION INITIALIZATION'), findsOneWidget);
      expect(find.text('PREPARE FOR\nENGAGEMENT'), findsOneWidget);

      // Verify text inputs exist
      expect(find.byType(TextField), findsNWidgets(2));

      // Verify "START MATCH" button exists
      expect(find.text('START MATCH'), findsOneWidget);
    });
  });
}
