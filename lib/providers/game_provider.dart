import 'package:flutter/foundation.dart';
import '../models/puzzle_model.dart';
import '../models/user_progress_model.dart';
import '../services/storage_service.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  UserProgressModel? _userProgress;
  List<PuzzleModel> _puzzles = [];

  // 걸음 수 기반 힌트 획득 설정
  static const int stepsPerHint = 2000; // 2000보당 힌트 1개
  int _lastHintSteps = 0; // 마지막으로 힌트를 받은 걸음 수

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
    } else {
      // 저장된 오늘 걸음 수 기준으로 마지막 힌트 획득 기준 초기화
      _lastHintSteps = (_userProgress!.todaySteps ~/ stepsPerHint) * stepsPerHint;
    }
    notifyListeners();
  }

  void _initializePuzzles() {
    _puzzles = [
      // 스테이지 1: 쉬움
      PuzzleModel(
        id: 'puzzle_001',
        title: '스테이지 1',
        description: '첫 번째 퍼즐입니다. Water Sort 게임을 즐겨보세요!',
        imageUrl: '',
        difficulty: 1,
        gridRows: 5,
        gridColumns: 5,
        answer: '시작',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 2: 쉬움
      PuzzleModel(
        id: 'puzzle_002',
        title: '스테이지 2',
        description: '두 번째 스테이지입니다. 색상을 잘 구분해보세요!',
        imageUrl: '',
        difficulty: 1,
        gridRows: 5,
        gridColumns: 5,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 3: 일반
      PuzzleModel(
        id: 'puzzle_003',
        title: '스테이지 3',
        description: '난이도가 조금 올라갑니다. 2km를 걸으면 잠금 해제!',
        imageUrl: '',
        difficulty: 2,
        gridRows: 6,
        gridColumns: 6,
        answer: '',
        hints: [],
        requiredSteps: 2620, // 약 2km
        hintsAvailable: 0,
      ),
      // 스테이지 4: 일반
      PuzzleModel(
        id: 'puzzle_004',
        title: '스테이지 4',
        description: '점점 복잡해집니다. 집중력을 발휘하세요!',
        imageUrl: '',
        difficulty: 2,
        gridRows: 6,
        gridColumns: 6,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 5: 일반
      PuzzleModel(
        id: 'puzzle_005',
        title: '스테이지 5',
        description: '중간 난이도 스테이지입니다.',
        imageUrl: '',
        difficulty: 2,
        gridRows: 6,
        gridColumns: 6,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 6: 어려움
      PuzzleModel(
        id: 'puzzle_006',
        title: '스테이지 6',
        description: '고난이도 스테이지! 5km를 걸으면 잠금 해제됩니다.',
        imageUrl: '',
        difficulty: 3,
        gridRows: 7,
        gridColumns: 7,
        answer: '',
        hints: [],
        requiredSteps: 6562, // 약 5km
        hintsAvailable: 0,
      ),
      // 스테이지 7: 어려움
      PuzzleModel(
        id: 'puzzle_007',
        title: '스테이지 7',
        description: '많은 색상을 정리해야 합니다. 신중하게 움직이세요!',
        imageUrl: '',
        difficulty: 3,
        gridRows: 7,
        gridColumns: 7,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 8: 매우 어려움
      PuzzleModel(
        id: 'puzzle_008',
        title: '스테이지 8',
        description: '챌린지 레벨! 10km를 걸으면 잠금 해제됩니다.',
        imageUrl: '',
        difficulty: 4,
        gridRows: 8,
        gridColumns: 8,
        answer: '',
        hints: [],
        requiredSteps: 13123, // 약 10km
        hintsAvailable: 0,
      ),
      // 스테이지 9: 매우 어려움
      PuzzleModel(
        id: 'puzzle_009',
        title: '스테이지 9',
        description: '최고 난이도 직전! 인내심이 필요합니다.',
        imageUrl: '',
        difficulty: 4,
        gridRows: 8,
        gridColumns: 8,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
      ),
      // 스테이지 10: 지옥
      PuzzleModel(
        id: 'puzzle_010',
        title: '스테이지 10',
        description: '최종 보스! 모든 스킬을 동원해 클리어하세요!',
        imageUrl: '',
        difficulty: 4,
        gridRows: 8,
        gridColumns: 8,
        answer: '',
        hints: [],
        requiredSteps: 0,
        hintsAvailable: 0,
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

    // 걸음 수 기반 힌트 획득 체크
    await _checkAndRewardHints(todaySteps);

    _userProgress = _userProgress!.copyWith(
      todaySteps: todaySteps,
      totalSteps: totalSteps,
      totalDistance: distance,
      lastUpdated: DateTime.now(),
    );
    await _saveUserProgress();
    notifyListeners();
  }

  /// 걸음 수에 따라 힌트 보상 제공
  Future<void> _checkAndRewardHints(int todaySteps) async {
    if (_userProgress == null) return;

    // 오늘 걸음 수가 힌트 획득 기준을 넘었는지 확인
    final hintsEarned = todaySteps ~/ stepsPerHint;
    final previousHintsEarned = _lastHintSteps ~/ stepsPerHint;

    if (hintsEarned > previousHintsEarned) {
      final newHints = hintsEarned - previousHintsEarned;
      _userProgress = _userProgress!.copyWith(
        availableHints: _userProgress!.availableHints + newHints,
        lastUpdated: DateTime.now(),
      );
      _lastHintSteps = todaySteps;
      print('🎁 걸음 수 보상: 힌트 $newHints개 획득! (${todaySteps}보 달성)');
    }

    // 걸음 수 기반 퍼즐 잠금 해제 체크
    await _checkAndUnlockPuzzlesBySteps(todaySteps);
  }

  /// 걸음 수에 따라 퍼즐 자동 잠금 해제
  Future<void> _checkAndUnlockPuzzlesBySteps(int todaySteps) async {
    if (_userProgress == null) return;

    bool hasUnlockedAny = false;

    for (final puzzle in _puzzles) {
      // 이미 잠금 해제된 퍼즐은 스킵
      if (_userProgress!.isPuzzleUnlocked(puzzle.id)) continue;

      // 위치 기반 퍼즐은 스킵 (GPS로만 잠금 해제)
      if (puzzle.isLocationBased) continue;

      // 필요한 걸음 수를 충족했는지 확인
      if (todaySteps >= puzzle.requiredSteps) {
        await unlockPuzzle(puzzle.id);
        hasUnlockedAny = true;
        print('🔓 걸음 수 잠금 해제: ${puzzle.title} (${todaySteps}/${puzzle.requiredSteps}보)');
      }
    }

    if (hasUnlockedAny) {
      notifyListeners();
    }
  }

  /// 오늘 걸음 수 기준으로 다음 힌트까지 남은 걸음 수 계산
  int getStepsUntilNextHint(int todaySteps) {
    final nextMilestone = ((todaySteps ~/ stepsPerHint) + 1) * stepsPerHint;
    return nextMilestone - todaySteps;
  }

  /// 오늘 걸음 수로 받을 수 있는 총 힌트 개수
  int getTotalHintsFromSteps(int todaySteps) {
    return todaySteps ~/ stepsPerHint;
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
