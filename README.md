# Walking Puzzle Game (걸으면 풀리는 퍼즐)

**광고 없는 모바일 퍼즐 게임**으로, 신체 활동(걷기/달리기)과 게임을 결합하여 사용자에게 운동 동기를 부여합니다.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev/)

---

## 📖 프로젝트 개요

### 주요 기능

- **일반 퍼즐 스테이지**: 두뇌로만 풀 수 있는 기본 퍼즐
- **난이도 높은 스테이지**: 걷기를 통해 잠금 해제
  - 예: 2km 걷기 → 퍼즐 힌트 1개
  - 5km 걷기 → 스테이지 클리어
- **위치 기반 콘텐츠**: 한국 주요 랜드마크(N서울타워, 북촌, 제주 한라산 등) 방문 시 특별 퍼즐 잠금 해제
- **GPS 추적 및 만보계 통합**

### 기술 스택

- **프레임워크**: Flutter 3.x
- **언어**: Dart
- **지도**: Google Maps / Kakao Maps (한국 최적화)
- **센서**: Pedometer, Health API (걸음 수 추적)
- **상태 관리**: Provider
- **로컬 저장소**: SharedPreferences

---

## 🎮 구현된 게임

### Water Sort Puzzle

완전히 구현된 물 정렬 퍼즐 게임:

- **4단계 난이도**: 쉬움, 일반, 어려움, 지옥
- **이동 횟수 제한**: 난이도별 최대 이동 횟수 (30~60회)
- **별점 평가 시스템**: ⭐⭐⭐ (70% 이하), ⭐⭐ (90% 이하), ⭐ (클리어)
- **색약 모드 지원**: 접근성 향상
- **AI 기반 힌트 시스템**: 최선의 이동 제안 및 자동 실행
- **순차적 스테이지 진행**: 이전 스테이지 완료 시 다음 스테이지 잠금 해제

---

## 🚀 시작하기

### 필수 요구 사항

- Flutter SDK 3.x 이상
- Dart SDK 3.x 이상
- iOS: Xcode 및 Apple Developer 계정 (실기기 테스트)
- Android: Android Studio

### 설치 및 실행

1. **저장소 클론**:
   ```bash
   git clone https://github.com/lukaPlayground/walking-puzzle-game.git
   cd walking_puzzle_game
   ```

2. **패키지 설치**:
   ```bash
   flutter pub get
   ```

3. **iOS 설정** (iOS 실기기 테스트 시):
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **앱 실행**:
   ```bash
   flutter run
   ```

### 주요 패키지

```yaml
dependencies:
  # 위치 및 센서
  geolocator: ^13.0.2          # GPS 위치 추적
  pedometer: ^4.0.2            # 걸음 수 측정
  google_maps_flutter: ^2.10.0 # Google Maps 통합
  permission_handler: ^11.3.1  # 권한 관리

  # 상태 관리 및 저장소
  provider: ^6.1.2             # 상태 관리
  shared_preferences: ^2.3.5   # 로컬 데이터 저장
```

---

## 📁 프로젝트 구조

```
lib/
├── main.dart                              # 앱 진입점 및 네비게이션
├── models/
│   ├── puzzle_model.dart                  # 퍼즐 데이터 모델
│   ├── user_progress_model.dart           # 사용자 진행 상황 모델
│   ├── location_model.dart                # 위치 및 랜드마크 모델
│   └── water_tube.dart                    # Water Sort Puzzle 튜브 모델
├── services/
│   ├── permission_service.dart            # 권한 관리 서비스
│   ├── location_service.dart              # 위치 추적 서비스
│   ├── pedometer_service.dart             # 걸음 수 측정 서비스
│   └── storage_service.dart               # 로컬 저장소 서비스
├── providers/
│   ├── game_provider.dart                 # 게임 상태 관리
│   ├── step_counter_provider.dart         # 걸음 수 상태 관리
│   └── location_provider.dart             # 위치 상태 관리
├── screens/
│   ├── puzzle_list_screen.dart            # 퍼즐 목록 화면
│   ├── profile_screen.dart                # 내 정보 화면
│   └── water_sort_puzzle_screen.dart      # Water Sort Puzzle 게임 화면
└── widgets/                               # 재사용 가능한 위젯들
```

---

## ✅ 완료된 기능

### 기본 인프라
- ✅ Flutter 프로젝트 설정 및 패키지 설치
- ✅ iOS 권한 설정 (위치, 모션 센서)
- ✅ Provider 기반 상태 관리
- ✅ 로컬 데이터 저장 (SharedPreferences)

### Water Sort Puzzle 게임
- ✅ 완전한 게임 로직 구현
- ✅ 난이도별 퍼즐 생성 (4단계)
- ✅ 이동 횟수 제한 및 별점 평가
- ✅ 색약 모드 지원
- ✅ AI 기반 힌트 시스템

### 게임 진행 시스템
- ✅ 스테이지 잠금/해제 시스템
- ✅ 퍼즐 완료 시 자동 저장
- ✅ 순차적 스테이지 진행
- ✅ 진행 상황 통계

### UI/UX
- ✅ 퍼즐 목록 화면
- ✅ 내 정보 통계 화면
- ✅ 하단 네비게이션 바
- ✅ Material Design 3 적용

---

## 🔜 다음 단계

1. **걸음 수 연동 시스템 (핵심)**
   - 걸음 수에 따른 힌트 획득 시스템
   - 특정 거리 달성 시 스테이지 잠금 해제
   - 일일 목표 달성 보상

2. **위치 기반 특별 퍼즐**
   - Google Maps 통합
   - 랜드마크 방문 시 특별 퍼즐 잠금 해제
   - 지도에 랜드마크 마커 표시

3. **추가 퍼즐 타입**
   - 색상 매칭 퍼즐
   - 일반 조각 맞추기 퍼즐
   - 다양한 난이도 및 테마

4. **실제 기기 테스트 및 최적화**
   - iOS 실제 기기에서 걸음 수 및 위치 추적 테스트
   - Android 기기 테스트
   - 배터리 최적화

---

## 📝 참고 사항

- **실제 기기 테스트 필수**: GPS 및 걸음 수 센서는 에뮬레이터에서 정확히 시뮬레이션할 수 없으므로 실제 iOS/Android 기기에서 테스트 필요
- **배포 비용**: Apple Developer ($99/년), Google Play ($25 1회)
- **타겟 지역**: 초기에는 한국 10대 도시, 다운로드 수에 따라 국제 확장 예정

---

## 📚 참고 자료

- [프로젝트 기획 및 목적](https://lukaplayground.tistory.com/2)
- [기술 스택 및 구현 세부사항](https://lukaplayground.tistory.com/3)

---

## 📄 라이선스

이 프로젝트는 개인 프로젝트이며, 상업적 사용을 금지합니다.

## 👤 개발자

- **GitHub**: [@lukaPlayground](https://github.com/lukaPlayground)
- **Blog**: [lukaplayground.tistory.com](https://lukaplayground.tistory.com)
