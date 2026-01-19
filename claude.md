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

## 현재 프로젝트 구조

```
lib/
├── main.dart                              # 앱 진입점 및 HomeScreen
├── models/
│   ├── puzzle_model.dart                  # 퍼즐 데이터 모델
│   ├── user_progress_model.dart           # 사용자 진행 상황 모델
│   └── location_model.dart                # 위치 및 랜드마크 모델
├── services/
│   ├── permission_service.dart            # 권한 관리 서비스
│   ├── location_service.dart              # 위치 추적 서비스
│   ├── pedometer_service.dart             # 걸음 수 측정 서비스
│   └── storage_service.dart               # 로컬 저장소 서비스
├── providers/
│   ├── game_provider.dart                 # 게임 상태 관리
│   ├── step_counter_provider.dart         # 걸음 수 상태 관리
│   └── location_provider.dart             # 위치 상태 관리
├── screens/                               # (예정) 추가 화면들
├── widgets/                               # (예정) 재사용 위젯들
└── utils/                                 # (예정) 유틸리티 함수들
```

---

## 다음 단계 (예정)

1. **권한 관리 UI 구현**
   - 앱 시작 시 권한 요청 화면
   - 권한 거부 시 안내 UI 및 설정 화면 이동

2. **Google Maps 통합**
   - 지도 UI 구현
   - 현재 위치 표시
   - 랜드마크 마커 표시

3. **퍼즐 화면 UI 구현**
   - 퍼즐 목록 화면
   - 퍼즐 상세 화면
   - 걸음 수 기반 잠금 해제 UI

4. **퍼즐 게임 로직**
   - CustomPainter를 사용한 퍼즐 조각 렌더링
   - GestureDetector를 사용한 드래그 앤 드롭 인터랙션
   - 퍼즐 완성 검증 로직

5. **실제 기기 테스트**
   - iOS 실제 기기에서 걸음 수 및 위치 추적 테스트
   - Android 기기 테스트 (예정)

---

## 참고 사항

- **실제 기기 테스트 필수**: GPS 및 걸음 수 센서는 에뮬레이터에서 정확히 시뮬레이션할 수 없으므로 실제 iOS/Android 기기에서 테스트 필요
- **배포 비용**: Apple Developer ($99/년), Google Play ($25 1회)
- **개발 기간**: 약 2-3개월 예상
- **타겟 지역**: 초기에는 한국 10대 도시, 다운로드 수에 따라 국제 확장 예정
