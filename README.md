# Komkan Scoreboard

Komkan is a polished Flutter scorekeeper app designed for competitive matches, board games, and card game sessions. It lets you configure players, add round scores across a fixed match format, and track completed match history with persistence.

## Key Features

- Player setup with custom names
- Round-based score entry with automatic total calculation
- Seven-round match flow with match completion controls
- Persistent match history storage using shared preferences
- Dark and light theme toggle
- Quick access to match archives and history clearing

## Screens

- **Setup**: Enter player names and initialize a new match session.
- **Scoreboard**: Add rounds, enter scores for each player, and view live totals.
- **History**: Review completed match results, winner information, and match timestamps.

## Why Use Komkan

Komkan is ideal for anyone who wants a simple, modern scoreboard experience for competitive play. It focuses on elegant presentation, smooth match setup, and quick reference to past results.

## Running the App

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. From the project root, run:

```bash
flutter pub get
flutter run
```

## Project Structure

- `lib/main.dart` — app entry point and navigation logic
- `lib/setup_screen.dart` — match initialization screen
- `lib/board_screen.dart` — round scoring and match controls
- `lib/history_screen.dart` — archived match history
- `lib/match_state.dart` — score, round, and persistence logic
- `lib/theme.dart` — app styling and theme definitions
