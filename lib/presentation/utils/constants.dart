import 'package:flutter/material.dart';

/// Game constants
class GameConstants {
  // Board dimensions
  static const int BOARD_SIZE = 4;

  // Tile values
  static const int TILE_ONE = 1;
  static const int TILE_TWO = 2;
  static const int TILE_THREE = 3;

  // Tile spawn probabilities (percentage)
  static const int SPAWN_CHANCE_ONE = 60;
  static const int SPAWN_CHANCE_TWO = 35;
  static const int SPAWN_CHANCE_THREE = 5;

  // Animation durations
  static const Duration TILE_APPEAR_DURATION = Duration(milliseconds: 350);
  static const Duration TILE_MERGE_DURATION = Duration(milliseconds: 250);
  static const Duration TILE_MOVE_DURATION = Duration(milliseconds: 300);

  // Animation delays
  static const Duration TILE_MOVE_DELAY = Duration(milliseconds: 50);
  static const Duration TILE_MERGE_DELAY = Duration(milliseconds: 100);

  // Storage keys
  static const String KEY_GAME_STATE = "game_state";
  static const String KEY_BEST_SCORE = "best_score";
  static const String KEY_STATS = "game_stats";
  static const String KEY_SETTINGS = "settings";

  // Game modes
  static const String KEY_ZEN_MODE_STATE = "zen_mode_state";
  static const String KEY_TIME_CHALLENGE_STATE = "time_challenge_state";
  static const String KEY_DARK_MODE_STATE = "dark_mode_state";

  // Time challenge constants
  static const Duration TIME_CHALLENGE_DURATION = Duration(minutes: 3);
}

/// Game mode enum
enum GameMode { classic, zen, timeChallenge, dark }

/// UI constants
class UIConstants {
  // Colors
  static const Color BACKGROUND_COLOR = Color(0xFF0D0D0D);
  static const Color SURFACE_COLOR = Color(0xFF1C1C1E);
  static const Color PURPLE_COLOR = Color(0xFF805AD5);
  static const Color CYAN_COLOR = Color(0xFF06B6D4);
  static const Color TEXT_COLOR = Colors.white;
  static const Color TEXT_SECONDARY_COLOR = Color(0xFFE2E8F0);

  // New UI colors
  static const Color GRID_BACKGROUND_COLOR = Color(0xFF1A1A1C);
  static const Color GRID_LINE_COLOR = Color(0xFF2A2A2E);
  static const Color EMPTY_CELL_COLOR = Color(0xFF262630);
  static const Color CARD_GRADIENT_START = Color(0xFF2D2D35);
  static const Color CARD_GRADIENT_END = Color(0xFF1A1A20);
  static const Color ACCENT_GLOW = Color(0x40805AD5);

  // Tile colors
  static const Color TILE_ONE_COLOR = Color(0xFF3B82F6); // Blue
  static const Color TILE_TWO_COLOR = Color(0xFFEF4444); // Red
  static const Color TILE_THREE_PLUS_COLOR = Colors.white; // White
  static const Color TILE_TEXT_COLOR = Colors.white;
  static const Color TILE_THREE_PLUS_TEXT_COLOR = Colors.black;

  // Dark mode colors
  static const Color DARK_MODE_BACKGROUND = Color(0xFF000000);
  static const Color DARK_MODE_SURFACE = Color(0xFF0A0A0A);
  static const Color DARK_MODE_ACCENT = Color(0xFF4B0082); // Indigo

  // Spacing
  static const double SPACING_SMALL = 8.0;
  static const double SPACING_MEDIUM = 16.0;
  static const double SPACING_LARGE = 24.0;

  // Border radius
  static const double BORDER_RADIUS_SMALL = 8.0;
  static const double BORDER_RADIUS_MEDIUM = 16.0;
  static const double BORDER_RADIUS_LARGE = 24.0;
  static const double BORDER_RADIUS_XLARGE = 32.0;

  // Glass card effect
  static const Color GLASS_CARD_COLOR = Color(0x801C1C1E);
  static const Color GLASS_CARD_BORDER_COLOR = Color(0x1AFFFFFF);
  static const double GLASS_CARD_BLUR = 20.0;
}

/// Text constants
class TextConstants {
  static const String APP_NAME = "Coria";
  static const String APP_TAGLINE = "Focus Through Fusion";

  // Home screen
  static const String START_GAME = "Start Game";
  static const String LEVEL_CHALLENGE = "Level Challenge";
  static const String HOW_TO_PLAY = "How to Play";
  static const String STATS = "Statistics";
  static const String SETTINGS = "Settings";

  // Game screen
  static const String CLASSIC_MODE = "Classic Mode";
  static const String SCORE = "SCORE";
  static const String BEST = "BEST";
  static const String NEXT = "NEXT";
  static const String TIME_LEFT = "TIME LEFT";

  // Level challenge screen
  static const String ZEN_MODE = "Zen Mode";
  static const String ZEN_MODE_DESC = "Endless relaxing journey";
  static const String TIME_CHALLENGE = "Time Challenge";
  static const String TIME_CHALLENGE_DESC = "Get high score in 3 minutes";
  static const String DARK_MODE = "Dark Mode";
  static const String COMING_SOON = "Coming soon...";

  // How to play screen
  static const String BASIC_RULES = "Basic Rules";
  static const String SWIPE = "Swipe";
  static const String SWIPE_DESC =
      "Swipe in any direction (up, down, left, right) to move all tiles on the board.";
  static const String MERGE = "Merge";
  static const String MERGE_DESC =
      "Identical tiles merge into a new tile with double value. 1+2 is the only exception, they merge into 3.";
  static const String CORE_STRATEGY = "Core Strategy";
  static const String PREDICT_NEW_TILES = "Predict New Tiles";
  static const String PREDICT_NEW_TILES_DESC =
      "After each swipe, a new tile appears from the opposite edge. Watch the \"NEXT\" hint to plan ahead.";
  static const String SPACE_MANAGEMENT = "Space Management";
  static const String SPACE_MANAGEMENT_DESC =
      "Keep high-value tiles in corners to leave space for new tiles and merging low-value tiles.";
  static const String GAME_OVER = "Game Over";
  static const String GAME_OVER_DESC =
      "Game ends when all 16 cells are filled and no moves are possible in any direction. Think carefully!";

  // Stats screen
  static const String HIGHEST_SCORE = "Highest Score";
  static const String MAX_TILE = "Max Tile";
  static const String TOTAL_GAMES = "Total Games";
  static const String TOTAL_TIME = "Total Play Time";
  static const String TILE_MERGE_STATS = "Tile Merge Statistics";

  // Settings screen
  static const String SOUND = "Sound";
  static const String HAPTIC_FEEDBACK = "Haptic Feedback";
  static const String RESET_HIGH_SCORE = "Reset High Score";

  // Game over screen
  static const String BOARD_LOCKED = "Board Locked";
  static const String MOMENT_OF_PEACE = "A moment of peace.";
  static const String FINAL_SCORE = "Final Score";
  static const String TRY_AGAIN = "Try Again";
  static const String BACK_TO_HOME = "Home";

  // Game mode descriptions
  static const String TIME_UP = "Time's Up!";
  static const String ZEN_MODE_ENDLESS = "Zen Mode - No Game Over";
  static const String DARK_MODE_TITLE = "Dark Mode";
}
