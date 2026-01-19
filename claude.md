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

---

## 다음 단계 (예정)

1. **기본 앱 아키텍처 설계**
   - Provider를 사용한 상태 관리 구조 설계
   - 폴더 구조 정리 (models, services, screens, widgets)

2. **권한 관리 구현**
   - permission_handler를 사용한 위치 및 센서 권한 요청 로직
   - 권한 거부 시 안내 UI

3. **위치 서비스 구현**
   - geolocator를 사용한 실시간 위치 추적
   - 백그라운드 위치 업데이트

4. **걸음 수 측정 기능**
   - pedometer 패키지를 사용한 실시간 걸음 수 추적
   - 걸음 수 데이터 저장 및 관리

5. **Google Maps 통합**
   - 지도 UI 구현
   - 현재 위치 표시
   - 랜드마크 마커 표시

6. **퍼즐 게임 로직**
   - CustomPainter를 사용한 퍼즐 조각 렌더링
   - GestureDetector를 사용한 드래그 앤 드롭 인터랙션
   - 퍼즐 완성 검증 로직

7. **데이터 영속성**
   - shared_preferences를 사용한 로컬 데이터 저장
   - 사용자 진행 상황 저장/불러오기

---

## 참고 사항

- **실제 기기 테스트 필수**: GPS 및 걸음 수 센서는 에뮬레이터에서 정확히 시뮬레이션할 수 없으므로 실제 iOS/Android 기기에서 테스트 필요
- **배포 비용**: Apple Developer ($99/년), Google Play ($25 1회)
- **개발 기간**: 약 2-3개월 예상
- **타겟 지역**: 초기에는 한국 10대 도시, 다운로드 수에 따라 국제 확장 예정
