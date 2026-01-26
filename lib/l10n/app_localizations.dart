import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'WalkingPuzzle'**
  String get appTitle;

  /// No description provided for @puzzle.
  ///
  /// In ko, this message translates to:
  /// **'퍼즐'**
  String get puzzle;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @collection.
  ///
  /// In ko, this message translates to:
  /// **'랜드마크 컬렉션'**
  String get collection;

  /// No description provided for @stepReward.
  ///
  /// In ko, this message translates to:
  /// **'걸음 수 보상'**
  String get stepReward;

  /// No description provided for @todaySteps.
  ///
  /// In ko, this message translates to:
  /// **'오늘 걸음 수'**
  String get todaySteps;

  /// No description provided for @hintsEarned.
  ///
  /// In ko, this message translates to:
  /// **'획득한 힌트'**
  String get hintsEarned;

  /// No description provided for @stepsToNextHint.
  ///
  /// In ko, this message translates to:
  /// **'다음 힌트까지 {steps}보 남음'**
  String stepsToNextHint(int steps);

  /// No description provided for @availableStages.
  ///
  /// In ko, this message translates to:
  /// **'플레이 가능한 스테이지'**
  String get availableStages;

  /// No description provided for @stage.
  ///
  /// In ko, this message translates to:
  /// **'스테이지'**
  String get stage;

  /// No description provided for @difficulty.
  ///
  /// In ko, this message translates to:
  /// **'난이도'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In ko, this message translates to:
  /// **'쉬움'**
  String get easy;

  /// No description provided for @normal.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get normal;

  /// No description provided for @hard.
  ///
  /// In ko, this message translates to:
  /// **'어려움'**
  String get hard;

  /// No description provided for @veryHard.
  ///
  /// In ko, this message translates to:
  /// **'매우 어려움'**
  String get veryHard;

  /// No description provided for @hell.
  ///
  /// In ko, this message translates to:
  /// **'지옥'**
  String get hell;

  /// No description provided for @locked.
  ///
  /// In ko, this message translates to:
  /// **'잠김'**
  String get locked;

  /// No description provided for @unlocked.
  ///
  /// In ko, this message translates to:
  /// **'잠금 해제됨'**
  String get unlocked;

  /// No description provided for @completed.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get completed;

  /// No description provided for @complete.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// No description provided for @walkToUnlock.
  ///
  /// In ko, this message translates to:
  /// **'걸어서 잠금 해제'**
  String get walkToUnlock;

  /// No description provided for @requiredSteps.
  ///
  /// In ko, this message translates to:
  /// **'필요한 걸음 수'**
  String get requiredSteps;

  /// No description provided for @stepsUnit.
  ///
  /// In ko, this message translates to:
  /// **'보'**
  String get stepsUnit;

  /// No description provided for @hints.
  ///
  /// In ko, this message translates to:
  /// **'힌트'**
  String get hints;

  /// No description provided for @availableHints.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 힌트'**
  String get availableHints;

  /// No description provided for @useHint.
  ///
  /// In ko, this message translates to:
  /// **'힌트 사용'**
  String get useHint;

  /// No description provided for @noHintsAvailable.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 힌트가 없습니다'**
  String get noHintsAvailable;

  /// No description provided for @appInfo.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// No description provided for @version.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In ko, this message translates to:
  /// **'앱 소개'**
  String get appDescription;

  /// No description provided for @appDescriptionText.
  ///
  /// In ko, this message translates to:
  /// **'걸으면 풀리는 퍼즐 게임'**
  String get appDescriptionText;

  /// No description provided for @dataManagement.
  ///
  /// In ko, this message translates to:
  /// **'데이터 관리'**
  String get dataManagement;

  /// No description provided for @resetProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 상황 초기화'**
  String get resetProgress;

  /// No description provided for @resetProgressDescription.
  ///
  /// In ko, this message translates to:
  /// **'모든 게임 진행 상황을 삭제합니다'**
  String get resetProgressDescription;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'진행 상황 초기화'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'모든 게임 진행 상황이 삭제됩니다.\\n이 작업은 되돌릴 수 없습니다.\\n\\n정말 초기화하시겠습니까?'**
  String get resetConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get reset;

  /// No description provided for @resetSuccess.
  ///
  /// In ko, this message translates to:
  /// **'진행 상황이 초기화되었습니다'**
  String get resetSuccess;

  /// No description provided for @gameStats.
  ///
  /// In ko, this message translates to:
  /// **'게임 통계'**
  String get gameStats;

  /// No description provided for @completedStages.
  ///
  /// In ko, this message translates to:
  /// **'완료한 스테이지'**
  String get completedStages;

  /// No description provided for @todayStepsCount.
  ///
  /// In ko, this message translates to:
  /// **'오늘 걸음 수'**
  String get todayStepsCount;

  /// No description provided for @stepsCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}보'**
  String stepsCount(int count);

  /// No description provided for @collectionStatus.
  ///
  /// In ko, this message translates to:
  /// **'수집 현황'**
  String get collectionStatus;

  /// No description provided for @landmarks.
  ///
  /// In ko, this message translates to:
  /// **'랜드마크'**
  String get landmarks;

  /// No description provided for @countries.
  ///
  /// In ko, this message translates to:
  /// **'국가'**
  String get countries;

  /// No description provided for @collectedCount.
  ///
  /// In ko, this message translates to:
  /// **'{collected} / {total} 수집'**
  String collectedCount(int collected, int total);

  /// No description provided for @notVisitedYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 방문하지 않음'**
  String get notVisitedYet;

  /// No description provided for @collected.
  ///
  /// In ko, this message translates to:
  /// **'수집 완료'**
  String get collected;

  /// No description provided for @currentProfileIcon.
  ///
  /// In ko, this message translates to:
  /// **'현재 프로필 아이콘'**
  String get currentProfileIcon;

  /// No description provided for @setAsProfileIcon.
  ///
  /// In ko, this message translates to:
  /// **'프로필 아이콘으로 설정'**
  String get setAsProfileIcon;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @profileIconSet.
  ///
  /// In ko, this message translates to:
  /// **'{icon} {name}을(를) 프로필 아이콘으로 설정했습니다'**
  String profileIconSet(String icon, String name);

  /// No description provided for @landmarkFound.
  ///
  /// In ko, this message translates to:
  /// **'{icon} {name} 발견!\\n힌트 +1'**
  String landmarkFound(String icon, String name);

  /// No description provided for @initializing.
  ///
  /// In ko, this message translates to:
  /// **'앱을 초기화하는 중...'**
  String get initializing;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettings;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @completed_exclamation.
  ///
  /// In ko, this message translates to:
  /// **'완료!'**
  String get completed_exclamation;

  /// No description provided for @failed_exclamation.
  ///
  /// In ko, this message translates to:
  /// **'이동 횟수 초과!'**
  String get failed_exclamation;

  /// No description provided for @perfect_clear.
  ///
  /// In ko, this message translates to:
  /// **'환상적입니다! {moves}번 만에 퍼즐을 완성했습니다!\\n⭐⭐⭐ 완벽한 클리어!'**
  String perfect_clear(int moves);

  /// No description provided for @great_clear.
  ///
  /// In ko, this message translates to:
  /// **'훌륭합니다! {moves}번 만에 퍼즐을 완성했습니다!\\n⭐⭐ 멋진 클리어!'**
  String great_clear(int moves);

  /// No description provided for @good_clear.
  ///
  /// In ko, this message translates to:
  /// **'성공! {moves}번 만에 퍼즐을 완성했습니다!\\n⭐ 클리어!'**
  String good_clear(int moves);

  /// No description provided for @max_moves_exceeded.
  ///
  /// In ko, this message translates to:
  /// **'최대 이동 횟수({maxMoves})를 초과했습니다.\\n다시 도전해보세요!'**
  String max_moves_exceeded(int maxMoves);

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @moves_count.
  ///
  /// In ko, this message translates to:
  /// **'이동 횟수'**
  String get moves_count;

  /// No description provided for @completed_tubes.
  ///
  /// In ko, this message translates to:
  /// **'완료된 튜브'**
  String get completed_tubes;

  /// No description provided for @hint_used.
  ///
  /// In ko, this message translates to:
  /// **'힌트를 사용했습니다! (남은 힌트: {remaining}개)'**
  String hint_used(int remaining);

  /// No description provided for @use_hint_count.
  ///
  /// In ko, this message translates to:
  /// **'힌트 사용 ({count}개)'**
  String use_hint_count(int count);

  /// No description provided for @colorblind_mode.
  ///
  /// In ko, this message translates to:
  /// **'색약 모드'**
  String get colorblind_mode;

  /// No description provided for @restart.
  ///
  /// In ko, this message translates to:
  /// **'다시 시작'**
  String get restart;

  /// No description provided for @new_board.
  ///
  /// In ko, this message translates to:
  /// **'새 판 생성'**
  String get new_board;

  /// No description provided for @new_board_generated.
  ///
  /// In ko, this message translates to:
  /// **'새로운 판을 생성했습니다!'**
  String get new_board_generated;

  /// No description provided for @no_more_moves.
  ///
  /// In ko, this message translates to:
  /// **'더 이상 이동할 수 없습니다'**
  String get no_more_moves;

  /// No description provided for @tutorial_title.
  ///
  /// In ko, this message translates to:
  /// **'게임 방법'**
  String get tutorial_title;

  /// No description provided for @tutorial_welcome.
  ///
  /// In ko, this message translates to:
  /// **'WalkingPuzzle에 오신 것을 환영합니다!'**
  String get tutorial_welcome;

  /// No description provided for @tutorial_step1_title.
  ///
  /// In ko, this message translates to:
  /// **'물 정렬 퍼즐'**
  String get tutorial_step1_title;

  /// No description provided for @tutorial_step1_desc.
  ///
  /// In ko, this message translates to:
  /// **'같은 색깔끼리 모아 튜브를 완성하세요'**
  String get tutorial_step1_desc;

  /// No description provided for @tutorial_step2_title.
  ///
  /// In ko, this message translates to:
  /// **'걸음 수 보상'**
  String get tutorial_step2_title;

  /// No description provided for @tutorial_step2_desc.
  ///
  /// In ko, this message translates to:
  /// **'걸으면서 힌트를 획득하고\\n새로운 스테이지를 잠금 해제하세요'**
  String get tutorial_step2_desc;

  /// No description provided for @tutorial_step3_title.
  ///
  /// In ko, this message translates to:
  /// **'랜드마크 수집'**
  String get tutorial_step3_title;

  /// No description provided for @tutorial_step3_desc.
  ///
  /// In ko, this message translates to:
  /// **'특별한 장소를 방문하여\\n랜드마크를 수집하세요'**
  String get tutorial_step3_desc;

  /// No description provided for @tutorial_start.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get tutorial_start;

  /// No description provided for @tutorial_next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get tutorial_next;

  /// No description provided for @tutorial_prev.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get tutorial_prev;

  /// No description provided for @all_stages_completed.
  ///
  /// In ko, this message translates to:
  /// **'🎉 모든 스테이지를 완료했습니다!'**
  String get all_stages_completed;

  /// No description provided for @congratulations.
  ///
  /// In ko, this message translates to:
  /// **'축하합니다!'**
  String get congratulations;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
