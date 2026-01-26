// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'WalkingPuzzle';

  @override
  String get puzzle => '퍼즐';

  @override
  String get settings => '설정';

  @override
  String get collection => '랜드마크 컬렉션';

  @override
  String get stepReward => '걸음 수 보상';

  @override
  String get todaySteps => '오늘 걸음 수';

  @override
  String get hintsEarned => '획득한 힌트';

  @override
  String stepsToNextHint(int steps) {
    return '다음 힌트까지 $steps보 남음';
  }

  @override
  String get availableStages => '플레이 가능한 스테이지';

  @override
  String get stage => '스테이지';

  @override
  String get difficulty => '난이도';

  @override
  String get easy => '쉬움';

  @override
  String get normal => '일반';

  @override
  String get hard => '어려움';

  @override
  String get veryHard => '매우 어려움';

  @override
  String get hell => '지옥';

  @override
  String get locked => '잠김';

  @override
  String get unlocked => '잠금 해제됨';

  @override
  String get completed => '완료';

  @override
  String get complete => '완료';

  @override
  String get walkToUnlock => '걸어서 잠금 해제';

  @override
  String get requiredSteps => '필요한 걸음 수';

  @override
  String get stepsUnit => '보';

  @override
  String get hints => '힌트';

  @override
  String get availableHints => '사용 가능한 힌트';

  @override
  String get useHint => '힌트 사용';

  @override
  String get noHintsAvailable => '사용 가능한 힌트가 없습니다';

  @override
  String get appInfo => '앱 정보';

  @override
  String get version => '버전';

  @override
  String get appDescription => '앱 소개';

  @override
  String get appDescriptionText => '걸으면 풀리는 퍼즐 게임';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get resetProgress => '진행 상황 초기화';

  @override
  String get resetProgressDescription => '모든 게임 진행 상황을 삭제합니다';

  @override
  String get resetConfirmTitle => '진행 상황 초기화';

  @override
  String get resetConfirmMessage =>
      '모든 게임 진행 상황이 삭제됩니다.\\n이 작업은 되돌릴 수 없습니다.\\n\\n정말 초기화하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get reset => '초기화';

  @override
  String get resetSuccess => '진행 상황이 초기화되었습니다';

  @override
  String get gameStats => '게임 통계';

  @override
  String get completedStages => '완료한 스테이지';

  @override
  String get todayStepsCount => '오늘 걸음 수';

  @override
  String stepsCount(int count) {
    return '$count보';
  }

  @override
  String get collectionStatus => '수집 현황';

  @override
  String get landmarks => '랜드마크';

  @override
  String get countries => '국가';

  @override
  String collectedCount(int collected, int total) {
    return '$collected / $total 수집';
  }

  @override
  String get notVisitedYet => '아직 방문하지 않음';

  @override
  String get collected => '수집 완료';

  @override
  String get currentProfileIcon => '현재 프로필 아이콘';

  @override
  String get setAsProfileIcon => '프로필 아이콘으로 설정';

  @override
  String get close => '닫기';

  @override
  String profileIconSet(String icon, String name) {
    return '$icon $name을(를) 프로필 아이콘으로 설정했습니다';
  }

  @override
  String landmarkFound(String icon, String name) {
    return '$icon $name 발견!\\n힌트 +1';
  }

  @override
  String get initializing => '앱을 초기화하는 중...';

  @override
  String get language => '언어';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get completed_exclamation => '완료!';

  @override
  String get failed_exclamation => '이동 횟수 초과!';

  @override
  String perfect_clear(int moves) {
    return '환상적입니다! $moves번 만에 퍼즐을 완성했습니다!\\n⭐⭐⭐ 완벽한 클리어!';
  }

  @override
  String great_clear(int moves) {
    return '훌륭합니다! $moves번 만에 퍼즐을 완성했습니다!\\n⭐⭐ 멋진 클리어!';
  }

  @override
  String good_clear(int moves) {
    return '성공! $moves번 만에 퍼즐을 완성했습니다!\\n⭐ 클리어!';
  }

  @override
  String max_moves_exceeded(int maxMoves) {
    return '최대 이동 횟수($maxMoves)를 초과했습니다.\\n다시 도전해보세요!';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get confirm => '확인';

  @override
  String get moves_count => '이동 횟수';

  @override
  String get completed_tubes => '완료된 튜브';

  @override
  String hint_used(int remaining) {
    return '힌트를 사용했습니다! (남은 힌트: $remaining개)';
  }

  @override
  String use_hint_count(int count) {
    return '힌트 사용 ($count개)';
  }

  @override
  String get colorblind_mode => '색약 모드';

  @override
  String get restart => '다시 시작';

  @override
  String get new_board => '새 판 생성';

  @override
  String get new_board_generated => '새로운 판을 생성했습니다!';

  @override
  String get no_more_moves => '더 이상 이동할 수 없습니다';

  @override
  String get tutorial_title => '게임 방법';

  @override
  String get tutorial_welcome => 'WalkingPuzzle에 오신 것을 환영합니다!';

  @override
  String get tutorial_step1_title => '물 정렬 퍼즐';

  @override
  String get tutorial_step1_desc => '같은 색깔끼리 모아 튜브를 완성하세요';

  @override
  String get tutorial_step2_title => '걸음 수 보상';

  @override
  String get tutorial_step2_desc => '걸으면서 힌트를 획득하고\\n새로운 스테이지를 잠금 해제하세요';

  @override
  String get tutorial_step3_title => '랜드마크 수집';

  @override
  String get tutorial_step3_desc => '특별한 장소를 방문하여\\n랜드마크를 수집하세요';

  @override
  String get tutorial_start => '시작하기';

  @override
  String get tutorial_next => '다음';

  @override
  String get tutorial_prev => '이전';

  @override
  String get all_stages_completed => '🎉 모든 스테이지를 완료했습니다!';

  @override
  String get congratulations => '축하합니다!';
}
