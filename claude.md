# Walking Puzzle Game - 개발 진행 내역

## 프로젝트 개요

**프로젝트명**: Walking Puzzle Game (걸으면 풀리는 퍼즐)

**목적**: 광고 없는 모바일 퍼즐 게임으로, 신체 활동(걷기/달리기)과 게임을 결합하여 사용자에게 운동 동기를 부여합니다.

**주요 기능**:
- 일반 퍼즐 스테이지: 두뇌로만 풀 수 있는 기본 퍼즐
- 난이도 높은 스테이지: 걷기를 통해 잠금 해제 (예: 2km 걷기 → 퍼즐 힌트 1개, 5km 걷기 → 스테이지 클리어)
- 위치 기반 콘텐츠: 한국 주요 랜드마크(N서울타워, 북촌, 제주 한라산 등) 방문 시 특별 퍼즐 잠금 해제
- GPS 추적 및 만보계 통합

**기술 스택**:
- Flutter 3.x (크로스 플랫폼 개발)
- Dart 언어
- Google Maps / Kakao Maps (한국 최적화)
- 걸음 수 추적 (Pedometer, Health API)
- 상태 관리 (Provider/Riverpod)

**참고 자료**:
- https://lukaplayground.tistory.com/2 - 프로젝트 기획 및 목적
- https://lukaplayground.tistory.com/3 - 기술 스택 및 구현 세부사항

---

## 작업 진행 내역

### 2026-01-19: Flutter 프로젝트 초기 설정

#### 1. Flutter 프로젝트 생성
- 프로젝트명: `walking_puzzle_game`
- Organization: `com.lukaplayground`
- 개발자 계정: Apple Development (ehowlrhdid2@gmail.com)

```bash
flutter create . --org com.lukaplayground --project-name walking_puzzle_game
```

#### 2. 필수 패키지 설치

`pubspec.yaml`에 다음 패키지들을 추가하고 설치 완료:

```yaml
dependencies:
  # Location and sensor packages
  geolocator: ^13.0.2          # GPS 위치 추적
  pedometer: ^4.0.2            # 걸음 수 측정
  google_maps_flutter: ^2.10.0 # Google Maps 통합
  permission_handler: ^11.3.1  # 권한 관리

  # State management
  provider: ^6.1.2             # 상태 관리
```

**설치된 패키지 버전**:
- geolocator: 13.0.4
- pedometer: 4.1.1
- google_maps_flutter: 2.14.0
- permission_handler: 11.4.0
- provider: 6.1.5+1

#### 3. iOS 권한 설정

`ios/Runner/Info.plist`에 위치 및 모션 센서 권한 추가:

**추가된 권한**:
- `NSLocationWhenInUseUsageDescription`: 앱 사용 중 위치 정보 접근
- `NSLocationAlwaysAndWhenInUseUsageDescription`: 백그라운드 위치 정보 접근
- `NSLocationAlwaysUsageDescription`: 항상 위치 정보 접근
- `NSMotionUsageDescription`: 걸음 수 측정을 위한 모션 센서 접근
- `UIBackgroundModes`: 백그라운드에서 위치 추적 및 fetch 기능

**권한 설명 텍스트** (한국어):
- 위치: "위치 기반 퍼즐 기능을 사용하기 위해 현재 위치 정보가 필요합니다."
- 백그라운드 위치: "앱이 백그라운드에서도 걸음 수를 추적하여 퍼즐 진행 상황을 업데이트하기 위해 위치 정보가 필요합니다."
- 모션: "걸음 수를 측정하여 퍼즐 힌트와 스테이지를 잠금 해제하기 위해 모션 센서 접근이 필요합니다."

---

## 프로젝트 구조

```
walking_puzzle_game/
├── android/                  # Android 네이티브 코드
├── ios/                      # iOS 네이티브 코드
│   └── Runner/
│       └── Info.plist       # iOS 권한 설정 완료
├── lib/
│   └── main.dart            # Flutter 메인 진입점
├── pubspec.yaml             # 패키지 의존성 관리
└── claude.md                # 개발 진행 내역 (현재 문서)
```

#### 4. Git 저장소 설정 및 GitHub 푸시

- Git 저장소 초기화 및 main 브랜치 설정
- Remote repository 추가: https://github.com/lukaPlayground/walking-puzzle-game.git
- 초기 프로젝트 설정 커밋 및 푸시 완료
- 커밋 메시지: "Initial Flutter project setup"

---

### 2026-01-19: 앱 아키텍처 설계 및 구현

#### 1. 폴더 구조 생성

Walking Puzzle Game을 위한 체계적인 폴더 구조 생성:

```
lib/
├── models/         # 데이터 모델
├── services/       # 비즈니스 로직 및 외부 서비스 연동
├── providers/      # 상태 관리 (Provider 패턴)
├── screens/        # 화면 UI
├── widgets/        # 재사용 가능한 위젯
└── utils/          # 유틸리티 함수
```

#### 2. 데이터 모델 구현

**PuzzleModel** (`lib/models/puzzle_model.dart`):
- 퍼즐 정보 관리: ID, 제목, 설명, 난이도
- 위치 기반 퍼즐 지원: 위도/경도, 위치 기반 여부
- 필요한 걸음 수 및 사용 가능한 힌트 수 관리
- JSON 직렬화/역직렬화 지원

**UserProgressModel** (`lib/models/user_progress_model.dart`):
- 사용자 진행 상황 추적: 총 걸음 수, 오늘 걸음 수, 총 거리
- 완료/잠금 해제된 퍼즐 목록 관리
- 사용 가능한 힌트 수 관리
- 로컬 저장소 연동을 위한 JSON 변환

**LocationModel & LandmarkModel** (`lib/models/location_model.dart`):
- 위치 정보 관리: 위도, 경도, 정확도, 타임스탬프
- 두 위치 간 거리 계산 (Haversine formula)
- 랜드마크 정보: N서울타워, 북촌 한옥마을, 한라산 등
- 사용자가 랜드마크 근처에 있는지 확인하는 로직

#### 3. 서비스 레이어 구현

**PermissionService** (`lib/services/permission_service.dart`):
- 위치 권한 요청 및 확인
- 활동 인식(걸음 수) 권한 요청 및 확인
- 모든 권한 일괄 요청 및 상태 확인
- 앱 설정 화면 열기 기능

**LocationService** (`lib/services/location_service.dart`):
- 현재 위치 조회 (고정밀도)
- 실시간 위치 추적 시작/정지
- 위치 스트림을 통한 지속적인 위치 업데이트
- 두 위치 간 거리 계산 헬퍼 메서드
- 권한 확인 및 위치 서비스 활성화 검증

**PedometerService** (`lib/services/pedometer_service.dart`):
- 실시간 걸음 수 추적
- 보행자 상태 모니터링 (걷는 중/정지)
- 일일 걸음 수 초기화 및 관리
- 걸음 수를 거리(km)와 칼로리로 변환
- 에러 핸들링 및 스트림 관리

**StorageService** (`lib/services/storage_service.dart`):
- shared_preferences를 사용한 로컬 데이터 저장
- 사용자 진행 상황 저장/불러오기
- 일일 걸음 수 초기화 시점 관리
- 날짜 변경 시 자동 리셋 로직

**추가 패키지 설치**:
- `shared_preferences: ^2.3.5` - 로컬 데이터 저장

#### 4. Provider 상태 관리 구현

**StepCounterProvider** (`lib/providers/step_counter_provider.dart`):
- 실시간 걸음 수 추적 및 상태 관리
- 오늘 걸음 수, 총 걸음 수, 거리, 칼로리 계산
- 보행자 상태 (걷는 중/정지) 관리
- 일일 걸음 수 자동 리셋 (자정 기준)
- 로컬 저장소와 동기화

**LocationProvider** (`lib/providers/location_provider.dart`):
- 현재 위치 추적 및 업데이트
- 랜드마크 목록 관리 (N서울타워, 북촌, 한라산)
- 사용자가 랜드마크 근처에 있는지 확인
- 특정 랜드마크까지의 거리 계산
- 위치 추적 시작/정지 제어

**GameProvider** (`lib/providers/game_provider.dart`):
- 게임 전체 상태 관리
- 퍼즐 목록 및 진행 상황 관리
- 퍼즐 잠금 해제/완료 로직
- 힌트 추가/사용 관리
- 걸음 수에 따른 퍼즐 자동 잠금 해제
- 로컬 저장소와 동기화

#### 5. main.dart 업데이트

**MultiProvider 설정**:
- GameProvider, StepCounterProvider, LocationProvider 등록
- 앱 시작 시 모든 Provider 초기화
- 자동으로 걸음 수 추적 및 위치 추적 시작

**HomeScreen 구현**:
- 실시간 걸음 수 표시 (아이콘, 숫자, 거리)
- 현재 위치 정보 표시 (위도, 경도)
- 게임 진행 상황 카드 (잠금 해제, 완료, 힌트)
- Material Design 3 적용
- 라이트/다크 테마 지원

---

### 2026-01-20: Water Sort Puzzle 게임 완성 및 힌트 시스템 구현

#### 1. Water Sort Puzzle 게임 로직 완성

**퍼즐 생성 로직 개선** (`lib/screens/water_sort_puzzle_screen.dart`):
- 난이도별 튜브 개수 및 색상 수 조정
  - 쉬움: 5개 튜브 (색상 3개 + 빈 튜브 2개)
  - 일반: 6개 튜브 (색상 4개 + 빈 튜브 2개)
  - 어려움: 7개 튜브 (색상 5개 + 빈 튜브 2개)
  - 지옥: 8개 튜브 (색상 6개 + 빈 튜브 2개)
- 퍼즐 ID 기반 시드로 동일한 배치 보장 (새로고침 시 일관성)
- 각 색상당 정확히 4개씩 생성하여 퍼즐 완성 가능

**이동 횟수 제한 추가**:
- 난이도별 최대 이동 횟수 설정
  - 쉬움: 30회, 일반: 40회, 어려움: 50회, 지옥: 60회
- 이동 횟수 시각적 피드백 (80% 초과 시 주황색, 초과 시 빨간색)
- 제한 초과 시 실패 처리

**승리 조건 개선**:
- 빈 튜브를 제외하고 모든 색상 튜브가 완성되었는지 확인
- `WaterTube.isSorted`: 빈 튜브는 완료로 계산하지 않도록 수정

**별점 평가 시스템**:
- ⭐⭐⭐: 최대 이동의 70% 이하
- ⭐⭐: 최대 이동의 90% 이하
- ⭐: 그 외 클리어

#### 2. 힌트 시스템 구현

**힌트 로직** (`lib/screens/water_sort_puzzle_screen.dart`):
- `_findBestMove()`: 최선의 이동 찾기
  - 1순위: 같은 색상끼리 합치기 (완성에 가까워짐)
  - 2순위: 빈 튜브로 이동 (공간 확보)
  - 3순위: 아무 가능한 이동
- `_useHint()`: 힌트 사용 시 자동으로 한 수 실행

**힌트 UI**:
- AppBar 우측: 💡 아이콘 + 빨간 뱃지에 힌트 개수 표시
- 정보 패널: "힌트 N개" 표시 (탭하여 사용)
- 내 정보 탭: 통계에서 사용 가능한 힌트 확인

**초기 힌트 제공**:
- 신규 유저: 힌트 3개로 시작
- GameProvider에서 관리 및 저장

#### 3. 스테이지 진행 시스템 개선

**퍼즐 목록 화면 개선** (`lib/screens/puzzle_list_screen.dart`):
- 완료된 스테이지는 목록에서 제거
- 현재 플레이 가능한 스테이지만 표시
- 진행 상황 카드: 완료 n/m, 총 스테이지
- 모든 스테이지 완료 시 축하 메시지

**스테이지 완료 시 자동 저장**:
- `WaterSortPuzzleScreen._showWinDialog()`: 퍼즐 완료 시 GameProvider에 저장
- 다음 스테이지 자동 잠금 해제
- 순차적 진행 시스템

**내 정보 탭 통계**:
- 완료한 스테이지 개수
- 사용 가능한 힌트
- 잠금 해제된 퍼즐 개수
- 걸음 수 및 거리, 칼로리

#### 4. 개발 편의 기능

**개발 모드 초기화** (`lib/providers/game_provider.dart`):
- `isDevelopmentMode` 플래그: 앱 재시작 시 진행 상황 초기화
- 배포 시 `false`로 변경하여 사용자 데이터 유지

**StorageService 확장**:
- `clearUserProgress()`: 사용자 진행 상황만 초기화
- 개발 테스트 용이성 향상

---

### 2026-01-23: 걸음 수 연동 시스템 구현 (HealthKit/Health Connect)

#### 1. health 패키지로 전환

**기존 pedometer 패키지 제거 및 health 패키지 설치**:
- `pedometer` → `health: ^10.2.0`로 교체
- iOS HealthKit 및 Android Health Connect 지원

**장점**:
- ✅ 시스템 헬스 앱(iOS 건강, Google Fit)의 걸음 수 데이터 활용
- ✅ 더 정확한 걸음 수 측정
- ✅ 백그라운드 자동 동기화
- ✅ 배터리 효율적
- ✅ 애플 워치 등 웨어러블 기기 데이터 통합

#### 2. iOS HealthKit 권한 설정

**Info.plist 업데이트**:
```xml
<key>NSHealthShareUsageDescription</key>
<string>건강 앱의 걸음 수 데이터를 읽어와 퍼즐 힌트와 스테이지를 잠금 해제하기 위해 필요합니다.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>건강 앱과 연동하여 걸음 수 데이터를 업데이트하기 위해 필요합니다.</string>
```

**Runner.entitlements 생성**:
- HealthKit capability 활성화
- `com.apple.developer.healthkit` 권한 추가

#### 3. Android Health Connect 권한 설정

**AndroidManifest.xml 업데이트**:
```xml
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.WRITE_STEPS"/>
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
```

**Health Connect 인텐트 필터 추가**:
- `androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE`
- `android.intent.action.VIEW_PERMISSION_USAGE`

#### 4. HealthService 구현

**새로운 HealthService** (`lib/services/health_service.dart`):
- `requestHealthPermissions()`: HealthKit/Health Connect 권한 요청
- `getTodaySteps()`: 오늘 자정부터 현재까지 걸음 수
- `getStepsInInterval()`: 특정 기간 걸음 수
- `getYesterdaySteps()`: 어제 걸음 수
- `getWeekSteps()`: 지난 7일 걸음 수
- `stepsToKilometers()`: 걸음 수 → 거리(km) 변환
- `stepsToCalories()`: 걸음 수 → 칼로리 변환

**pedometer_service.dart 삭제**: 더 이상 사용하지 않음

#### 5. StepCounterProvider 리팩토링

**health 패키지 기반으로 재구현**:
- 실시간 스트림 대신 **30초마다 주기적으로 걸음 수 업데이트**
- `Timer.periodic`을 사용하여 백그라운드에서 지속적으로 데이터 갱신
- `fetchTodaySteps()`: HealthKit/Health Connect에서 최신 걸음 수 가져오기
- 자정 기준 일일 걸음 수 자동 리셋

**주요 메서드**:
- `initialize()`: 권한 요청 및 초기 데이터 로드
- `startTracking()`: 30초마다 걸음 수 업데이트 시작
- `stopTracking()`: 추적 중지
- `getYesterdaySteps()`, `getWeekSteps()`: 통계 데이터

#### 6. 걸음 수 기반 힌트 획득 시스템

**GameProvider 업데이트**:
- **2000보당 힌트 1개 자동 지급**
- `stepsPerHint = 2000` 상수 정의
- `_checkAndRewardHints()`: 걸음 수 달성 시 힌트 자동 추가
- `getStepsUntilNextHint()`: 다음 힌트까지 남은 걸음 수 계산
- `getTotalHintsFromSteps()`: 오늘 걸음 수로 받은 총 힌트 개수

**자동 보상 로직**:
```dart
// 예: 4500보 걸었을 때
// - 힌트 2개 획득 (2000보, 4000보 달성)
// - 다음 힌트까지 1500보 남음 (6000보 목표)
```

#### 7. 걸음 수 기반 스테이지 잠금 해제 시스템

**자동 잠금 해제 로직** (`GameProvider._checkAndUnlockPuzzlesBySteps()`):
- 퍼즐의 `requiredSteps` 속성 기준으로 자동 잠금 해제
- 예시:
  - 스테이지 2: 2620보 (약 2km) 필요
  - 스테이지 3: 6562보 (약 5km) 필요
- 위치 기반 퍼즐은 제외 (GPS로만 잠금 해제)

**StepCounterProvider와 GameProvider 연동** (`main.dart`):
```dart
stepCounterProvider.addListener(() {
  gameProvider.updateSteps(
    stepCounterProvider.todaySteps,
    stepCounterProvider.totalSteps,
  );
});
```

#### 8. UI 업데이트: 걸음 수 보상 진행 표시

**PuzzleListScreen에 보상 카드 추가**:
- **걸음 수 보상 진행 바**: 다음 힌트까지 진행 상황 시각화
- **획득한 힌트 개수 표시**: 오늘 걸음 수로 받은 힌트 +N 표시
- **남은 걸음 수 안내**: "다음 힌트까지 N보 남음"
- Material Design 3 `primaryContainer` 색상 사용

**표시 정보**:
- 🚶 걸음 수 보상
- 💡 오늘 획득한 힌트 개수
- Progress Bar (0~2000보 구간)
- 다음 힌트까지 남은 걸음 수

---

## 현재 프로젝트 구조

```
lib/
├── main.dart                              # 앱 진입점 및 네비게이션
├── models/
│   ├── puzzle_model.dart                  # 퍼즐 데이터 모델
│   ├── user_progress_model.dart           # 사용자 진행 상황 모델
│   ├── location_model.dart                # 위치 및 랜드마크 모델
│   ├── water_tube.dart                    # Water Sort Puzzle 튜브 모델
│   ├── puzzle_piece.dart                  # 색상 퍼즐 조각 모델
│   └── color_tile.dart                    # 색상 타일 모델
├── services/
│   ├── permission_service.dart            # 권한 관리 서비스
│   ├── location_service.dart              # 위치 추적 서비스
│   ├── health_service.dart                # HealthKit/Health Connect 서비스 (NEW)
│   └── storage_service.dart               # 로컬 저장소 서비스
├── providers/
│   ├── game_provider.dart                 # 게임 상태 관리 + 걸음 수 보상 로직
│   ├── step_counter_provider.dart         # 걸음 수 상태 관리 (health 기반)
│   └── location_provider.dart             # 위치 상태 관리
├── screens/
│   ├── puzzle_list_screen.dart            # 퍼즐 목록 화면 + 걸음 수 보상 카드
│   ├── profile_screen.dart                # 내 정보 화면
│   ├── water_sort_puzzle_screen.dart      # Water Sort Puzzle 게임 화면
│   ├── color_puzzle_screen.dart           # 색상 퍼즐 게임 화면
│   └── puzzle_game_screen.dart            # 일반 퍼즐 게임 화면
└── widgets/                               # 재사용 가능한 위젯들
```

---

## 완료된 기능

### ✅ 기본 인프라
- Flutter 프로젝트 설정 및 패키지 설치
- iOS 권한 설정 (위치, 모션 센서, HealthKit)
- Android 권한 설정 (위치, Health Connect)
- Provider 기반 상태 관리
- 로컬 데이터 저장 (SharedPreferences)

### ✅ Water Sort Puzzle 게임
- 완전한 게임 로직 구현
- 난이도별 퍼즐 생성 (4단계)
- 이동 횟수 제한 및 별점 평가
- 색약 모드 지원
- 힌트 시스템 (AI 기반 최선의 이동 제안)

### ✅ 게임 진행 시스템
- 스테이지 잠금/해제 시스템
- 퍼즐 완료 시 자동 저장
- 순차적 스테이지 진행
- 진행 상황 통계

### ✅ 걸음 수 연동 시스템 (핵심 완료!)
- **HealthKit/Health Connect 통합**: iOS 건강 앱 및 Google Fit 데이터 활용
- **2000보당 힌트 1개 자동 지급**: 걷기만 하면 힌트 획득
- **걸음 수 기반 스테이지 잠금 해제**: 특정 거리 달성 시 새 퍼즐 해제
- **실시간 진행 상황 표시**: 다음 힌트까지 남은 걸음 수 및 진행 바
- **30초마다 자동 동기화**: 백그라운드에서 걸음 수 자동 업데이트

### ✅ UI/UX
- 퍼즐 목록 화면 + 걸음 수 보상 카드
- 내 정보 통계 화면
- 하단 네비게이션 바
- Material Design 3 적용
- 걸음 수 보상 진행 상황 시각화

## 다음 단계 (예정)

1. **위치 기반 특별 보상 (우선순위 높음)**
   - 백그라운드 GPS 감지 및 로컬 알림
   - 랜드마크 근처 도달 시 알림 발송
   - 보상 형태 결정 (힌트/퍼즐/아이콘 등)
   - 실제 기기에서 GPS 감지 테스트

2. **실제 기기 테스트 및 최적화**
   - iOS 실제 기기에서 HealthKit 연동 테스트
   - Android 기기에서 Health Connect 테스트
   - 백그라운드 위치 추적 배터리 최적화
   - 걸음 수 동기화 주기 최적화 (30초 → 조정 가능)

3. **추가 퍼즐 타입**
   - 색상 매칭 퍼즐
   - 일반 조각 맞추기 퍼즐
   - 다양한 난이도 및 테마

4. **사용자 경험 개선**
   - 튜토리얼 추가
   - 일일 목표 달성 보상
   - 배지/업적 시스템

---

## 참고 사항

- **실제 기기 테스트 필수**: GPS 및 걸음 수 센서는 에뮬레이터에서 정확히 시뮬레이션할 수 없으므로 실제 iOS/Android 기기에서 테스트 필요
- **배포 비용**: Apple Developer ($99/년), Google Play ($25 1회)
- **개발 기간**: 약 2-3개월 예상
- **타겟 지역**: 초기에는 한국 10대 도시, 다운로드 수에 따라 국제 확장 예정
