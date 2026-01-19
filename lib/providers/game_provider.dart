import 'package:flutter/foundation.dart';
import '../models/puzzle_model.dart';
import '../models/user_progress_model.dart';
import '../services/storage_service.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  UserProgressModel? _userProgress;
  List<PuzzleModel> _puzzles = [];

  UserProgressModel? get userProgress => _userProgress;
  List<PuzzleModel> get puzzles => _puzzles;
  List<PuzzleModel> get availablePuzzles => _puzzles
      .where((p) => _userProgress?.isPuzzleUnlocked(p.id) ?? false)
      .toList();
  List<PuzzleModel> get completedPuzzles => _puzzles
      .where((p) => _userProgress?.isPuzzleCompleted(p.id) ?? false)
      .toList();

  Future<void> initialize() async {
    await _loadUserProgress();
    _initializePuzzles();
  }

  Future<void> _loadUserProgress() async {
    _userProgress = await _storageService.loadUserProgress();

    if (_userProgress == null) {
      _userProgress = UserProgressModel(
        userId: 'user_001',
        lastUpdated: DateTime.now(),
        unlockedPuzzles: ['puzzle_001'],
      );
      await _saveUserProgress();
    }
    notifyListeners();
  }

  void _initializePuzzles() {
    _puzzles = [
      PuzzleModel(
        id: 'puzzle_001',
        title: '시작 퍼즐',
        description: '첫 번째 퍼즐입니다. 간단한 문제로 시작해보세요!',
        imageUrl: 'assets/puzzles/puzzle_001.jpg',
        difficulty: 1,
        requiredSteps: 0,
        hintsAvailable: 3,
      ),
      PuzzleModel(
        id: 'puzzle_002',
        title: '2km 걷기 퍼즐',
        description: '2km를 걸으면 힌트를 받을 수 있습니다.',
        imageUrl: 'assets/puzzles/puzzle_002.jpg',
        difficulty: 2,
        requiredSteps: 2620,
        hintsAvailable: 2,
      ),
      PuzzleModel(
        id: 'puzzle_003',
        title: '5km 걷기 퍼즐',
        description: '5km를 걸으면 자동으로 클리어됩니다!',
        imageUrl: 'assets/puzzles/puzzle_003.jpg',
        difficulty: 3,
        requiredSteps: 6562,
        hintsAvailable: 1,
      ),
      PuzzleModel(
        id: 'puzzle_seoul_tower',
        title: 'N서울타워 퍼즐',
        description: 'N서울타워 근처에서만 풀 수 있는 특별한 퍼즐입니다.',
        imageUrl: 'assets/puzzles/puzzle_seoul_tower.jpg',
        difficulty: 4,
        isLocationBased: true,
        latitude: 37.5512,
        longitude: 126.9882,
        requiredSteps: 0,
        hintsAvailable: 2,
      ),
    ];
    notifyListeners();
  }

  Future<void> unlockPuzzle(String puzzleId) async {
    if (_userProgress == null) return;

    final unlockedPuzzles = List<String>.from(_userProgress!.unlockedPuzzles);
    if (!unlockedPuzzles.contains(puzzleId)) {
      unlockedPuzzles.add(puzzleId);
      _userProgress = _userProgress!.copyWith(
        unlockedPuzzles: unlockedPuzzles,
        lastUpdated: DateTime.now(),
      );
      await _saveUserProgress();
      notifyListeners();
    }
  }

  Future<void> completePuzzle(String puzzleId) async {
    if (_userProgress == null) return;

    final completedPuzzles = List<String>.from(_userProgress!.completedPuzzles);
    if (!completedPuzzles.contains(puzzleId)) {
      completedPuzzles.add(puzzleId);
      _userProgress = _userProgress!.copyWith(
        completedPuzzles: completedPuzzles,
        lastUpdated: DateTime.now(),
      );
      await _saveUserProgress();
      notifyListeners();

      await _unlockNextPuzzle(puzzleId);
    }
  }

  Future<void> _unlockNextPuzzle(String completedPuzzleId) async {
    final completedIndex = _puzzles.indexWhere((p) => p.id == completedPuzzleId);
    if (completedIndex >= 0 && completedIndex < _puzzles.length - 1) {
      final nextPuzzle = _puzzles[completedIndex + 1];
      if (!nextPuzzle.isLocationBased) {
        await unlockPuzzle(nextPuzzle.id);
      }
    }
  }

  Future<void> addHint() async {
    if (_userProgress == null) return;

    _userProgress = _userProgress!.copyWith(
      availableHints: _userProgress!.availableHints + 1,
      lastUpdated: DateTime.now(),
    );
    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> useHint() async {
    if (_userProgress == null || _userProgress!.availableHints <= 0) return;

    _userProgress = _userProgress!.copyWith(
      availableHints: _userProgress!.availableHints - 1,
      lastUpdated: DateTime.now(),
    );
    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> updateSteps(int todaySteps, int totalSteps) async {
    if (_userProgress == null) return;

    final distance = todaySteps * 0.762 / 1000;

    _userProgress = _userProgress!.copyWith(
      todaySteps: todaySteps,
      totalSteps: totalSteps,
      totalDistance: distance,
      lastUpdated: DateTime.now(),
    );
    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> _saveUserProgress() async {
    if (_userProgress != null) {
      await _storageService.saveUserProgress(_userProgress!);
    }
  }

  PuzzleModel? getPuzzleById(String puzzleId) {
    try {
      return _puzzles.firstWhere((p) => p.id == puzzleId);
    } catch (e) {
      return null;
    }
  }

  PuzzleModel? getCurrentPuzzle() {
    if (_userProgress == null || _puzzles.isEmpty) return null;

    // Find the first unlocked puzzle that is not completed
    for (final puzzle in _puzzles) {
      final isUnlocked = _userProgress!.isPuzzleUnlocked(puzzle.id);
      final isCompleted = _userProgress!.isPuzzleCompleted(puzzle.id);

      if (isUnlocked && !isCompleted) {
        return puzzle;
      }
    }

    return null;
  }
}
