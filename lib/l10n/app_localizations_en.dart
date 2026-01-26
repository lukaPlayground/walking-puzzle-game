// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WalkingPuzzle';

  @override
  String get puzzle => 'Puzzle';

  @override
  String get settings => 'Settings';

  @override
  String get collection => 'Landmark Collection';

  @override
  String get stepReward => 'Step Reward';

  @override
  String get todaySteps => 'Today\'s Steps';

  @override
  String get hintsEarned => 'Hints Earned';

  @override
  String stepsToNextHint(int steps) {
    return '$steps steps until next hint';
  }

  @override
  String get availableStages => 'Available Stages';

  @override
  String get stage => 'Stage';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get normal => 'Normal';

  @override
  String get hard => 'Hard';

  @override
  String get veryHard => 'Very Hard';

  @override
  String get hell => 'Hell';

  @override
  String get locked => 'Locked';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get completed => 'Completed';

  @override
  String get complete => 'Complete';

  @override
  String get walkToUnlock => 'Walk to unlock';

  @override
  String get requiredSteps => 'Required Steps';

  @override
  String get stepsUnit => 'steps';

  @override
  String get hints => 'Hints';

  @override
  String get availableHints => 'Available Hints';

  @override
  String get useHint => 'Use Hint';

  @override
  String get noHintsAvailable => 'No hints available';

  @override
  String get appInfo => 'App Info';

  @override
  String get version => 'Version';

  @override
  String get appDescription => 'App Description';

  @override
  String get appDescriptionText => 'Puzzle game solved by walking';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get resetProgressDescription => 'Delete all game progress';

  @override
  String get resetConfirmTitle => 'Reset Progress';

  @override
  String get resetConfirmMessage =>
      'All game progress will be deleted.\\nThis action cannot be undone.\\n\\nAre you sure you want to reset?';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get resetSuccess => 'Progress has been reset';

  @override
  String get gameStats => 'Game Statistics';

  @override
  String get completedStages => 'Completed Stages';

  @override
  String get todayStepsCount => 'Today\'s Steps';

  @override
  String stepsCount(int count) {
    return '$count steps';
  }

  @override
  String get collectionStatus => 'Collection Status';

  @override
  String get landmarks => 'Landmarks';

  @override
  String get countries => 'Countries';

  @override
  String collectedCount(int collected, int total) {
    return '$collected / $total collected';
  }

  @override
  String get notVisitedYet => 'Not visited yet';

  @override
  String get collected => 'Collected';

  @override
  String get currentProfileIcon => 'Current Profile Icon';

  @override
  String get setAsProfileIcon => 'Set as Profile Icon';

  @override
  String get close => 'Close';

  @override
  String profileIconSet(String icon, String name) {
    return 'Set $icon $name as profile icon';
  }

  @override
  String landmarkFound(String icon, String name) {
    return '$icon $name found!\\nHint +1';
  }

  @override
  String get initializing => 'Initializing app...';

  @override
  String get retry => 'Retry';

  @override
  String get language => 'Language';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';
}
