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
    // 개발 모드: 앱 재시작 시 진행 상황 초기화
    const bool isDevelopmentMode = true; // 배포 시 false로 변경

    if (isDevelopmentMode) {
      await _storageService.clearUserProgress();
    }

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
        availableHints: 3, // 시작 시 힌트 3개 제공
      );
      await _saveUserProgress();
    }
    notifyListeners();
  }

  void _initializePuzzles() {
    _puzzles = [
      // 쉬움: 5x5 = 25조각
      PuzzleModel(
        id: 'puzzle_001',
        title: '스테이지 1',
        description: '첫 번째 퍼즐입니다. 숨겨진 단어를 찾아보세요!',
        imageUrl: '',
        difficulty: 1,
        gridRows: 5,
        gridColumns: 5,
        answer: '시작',
        hints: [
          '첫 번째 힌트: 무언가를 처음 하는 것',
          '두 번째 힌트: 출발과 비슷한 의미',
          '세 번째 힌트: ㅅㅈ',
        ],
        requiredSteps: 0,
        hintsAvailable: 3,
      ),
      // 일반: 5x10 = 50조각
      PuzzleModel(
        id: 'puzzle_002',
        title: '스테이지 2',
        description: '조금 더 많은 조각이 있습니다. 걸으면서 힌트를 얻으세요!',
        imageUrl: '',
        difficulty: 2,
        gridRows: 5,
        gridColumns: 10,
        answer: '일산호수공원',
        hints: [
          '첫 번째 힌트: 고양시에 있는 유명한 장소',
          '두 번째 힌트: 물과 자연이 있는 곳',
        ],
        requiredSteps: 2620,
        hintsAvailable: 2,
      ),
      // 어려움: 5x15 = 75조각
      PuzzleModel(
        id: 'puzzle_003',
        title: '스테이지 3',
        description: '더욱 많은 조각! 집중력이 필요합니다.',
        imageUrl: '',
        difficulty: 3,
        gridRows: 5,
        gridColumns: 15,
        answer: '퍼즐',
        hints: [
          '첫 번째 힌트: 조각을 맞추는 게임',
        ],
        requiredSteps: 6562,
        hintsAvailable: 1,
      ),
      // 매우 어려움: 10x10 = 100조각
      PuzzleModel(
        id: 'puzzle_004',
        title: '스테이지 4',
        description: '최고 난이도! 100개의 조각을 맞춰보세요.',
        imageUrl: '',
        difficulty: 4,
        gridRows: 10,
        gridColumns: 10,
        answer: '성공',
        hints: [
          '첫 번째 힌트: 목표를 이루었을 때',
          '두 번째 힌트: 실패의 반대',
        ],
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
