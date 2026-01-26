# 🚶‍♂️ Walking Puzzle Game (걸으면 풀리는 퍼즐)

**광고 없는 모바일 퍼즐 게임**으로, 신체 활동(걷기/달리기)과 게임을 결합하여 사용자에게 운동 동기를 부여합니다.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev/)
[![iOS](https://img.shields.io/badge/iOS-14.0+-black.svg)](https://www.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-API%2026+-green.svg)](https://www.android.com/)

---

## 🎮 주요 기능

### 1️⃣ Water Sort Puzzle 게임
- **4가지 난이도**: 쉬움, 일반, 어려움, 지옥
- **10개 스테이지**: 점진적인 난이도 상승
- **색약 모드 지원**: 접근성 고려
- **AI 힌트 시스템**: 막힐 때 최선의 이동 제안
- **별점 평가**: 효율성에 따른 1~3개 별 획득
- **이동 횟수 제한**: 난이도별 30~60회

### 2️⃣ 걸음 수 연동 시스템 (핵심!)
- **HealthKit (iOS) / Health Connect (Android) 통합**
  - iOS 건강 앱 및 Google Fit 데이터 활용
  - 애플 워치, Fitbit 등 웨어러블 기기 지원
  - 더 정확하고 배터리 효율적인 측정
  - 30초마다 자동 동기화

- **2000보당 힌트 1개 자동 지급**
  - 걷기만 하면 게임에 도움이 되는 힌트 획득
  - 실시간 진행 상황 표시 (Progress Bar)
  - 다음 힌트까지 남은 걸음 수 안내

- **걸음 수 기반 스테이지 잠금 해제**
  - 스테이지 3: 2km (약 2,620보) 걸으면 해제
  - 스테이지 6: 5km (약 6,562보) 걸으면 해제
  - 스테이지 8: 10km (약 13,123보) 걸으면 해제

### 3️⃣ 위치 기반 콘텐츠 (개발 예정)
- **한국 주요 랜드마크 방문 시 특별 보상**
  - N서울타워, 북촌 한옥마을, 제주 한라산 등
  - 백그라운드 GPS 감지로 자동 알림
  - 보상: 힌트, 특별 퍼즐, 캐릭터 아이콘 등

---

## 📱 지원 플랫폼

- **iOS**: 14.0 이상 (HealthKit 지원)
- **Android**: API 26 (Android 8.0) 이상 (Health Connect 지원)

---

## 🛠️ 기술 스택

### Frontend
- **Flutter 3.x**: 크로스 플랫폼 개발
- **Dart 3.x**: 언어
- **Material Design 3**: UI 디자인 시스템

### State Management & Storage
- **Provider**: 상태 관리
- **SharedPreferences**: 로컬 데이터 저장

### Health & Location
- **health: ^13.3.0**: HealthKit / Health Connect 통합
- **geolocator: ^13.0.2**: GPS 위치 추적
- **permission_handler: ^11.3.1**: 권한 관리

### Internationalization
- **flutter_localizations**: 다국어 지원 (한국어, English)
- **intl**: 국제화 및 현지화

---

## 🚀 시작하기

### 필수 요구사항

- **Flutter SDK**: 3.10.4 이상
- **Dart SDK**: 3.10.4 이상
- **iOS 개발**: Xcode 14 이상, macOS
- **Android 개발**: Android Studio

### 설치 및 실행

```bash
# 1. 저장소 클론
git clone https://github.com/lukaPlayground/walking-puzzle-game.git
cd walking_puzzle_game

# 2. 패키지 설치
flutter pub get

# 3. 다국어 파일 생성
flutter gen-l10n

# 4. iOS 의존성 설치 (macOS 전용)
cd ios && pod install && cd ..

# 5. 앱 실행
flutter run
```

### iOS HealthKit 설정

⚠️ **HealthKit은 실제 iOS 기기에서만 동작합니다.**
- 시뮬레이터에서는 권한 요청만 테스트할 수 있습니다.
- 실제 기기에서 테스트하려면 Apple Developer 계정이 필요합니다.

### Android Health Connect 설정

- **Android 14 (API 34) 이상**: Health Connect가 시스템에 내장
- **Android 13 이하**: Google Play에서 [Health Connect 앱](https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata) 별도 설치 필요

---

## 📂 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점 및 네비게이션
├── l10n/                        # 다국어 지원
│   ├── app_ko.arb              # 한국어 번역
│   ├── app_en.arb              # 영어 번역
│   └── app_localizations.dart  # 자동 생성된 localization 클래스
├── models/                      # 데이터 모델
│   ├── puzzle_model.dart        # 퍼즐 정보
│   ├── user_progress_model.dart # 사용자 진행 상황
│   ├── location_model.dart      # 위치 및 랜드마크
│   └── water_tube.dart          # Water Sort Puzzle 튜브
├── services/                    # 비즈니스 로직
│   ├── health_service.dart      # HealthKit/Health Connect
│   ├── location_service.dart    # GPS 추적
│   ├── permission_service.dart  # 권한 관리
│   └── storage_service.dart     # 로컬 저장
├── providers/                   # 상태 관리 (Provider 패턴)
│   ├── game_provider.dart       # 게임 + 걸음 수 보상
│   ├── step_counter_provider.dart # 걸음 수 추적
│   ├── location_provider.dart   # 위치 추적
│   └── locale_provider.dart     # 언어 설정
├── screens/                     # 화면 UI
│   ├── puzzle_list_screen.dart  # 퍼즐 목록 + 보상 진행
│   ├── water_sort_puzzle_screen.dart # Water Sort 게임
│   ├── settings_screen.dart     # 설정 및 언어 선택
│   └── collection_screen.dart   # 랜드마크 컬렉션
├── utils/                       # 유틸리티
│   └── app_identity.dart        # 개발자 아이덴티티
└── widgets/                     # 재사용 위젯
```

---

## ✅ 완료된 기능

### 기본 인프라
- ✅ Flutter 프로젝트 설정
- ✅ iOS HealthKit 권한 및 Entitlements 설정
- ✅ Android Health Connect 권한 설정
- ✅ Provider 기반 상태 관리
- ✅ SharedPreferences 로컬 저장

### Water Sort Puzzle 게임
- ✅ 완전한 게임 로직 구현
- ✅ 10개 스테이지 (난이도 4단계)
- ✅ 이동 횟수 제한 및 별점 평가
- ✅ 색약 모드 지원
- ✅ AI 힌트 시스템

### 걸음 수 연동 시스템 (핵심!)
- ✅ HealthKit/Health Connect 통합
- ✅ 2000보당 힌트 1개 자동 지급
- ✅ 걸음 수 기반 스테이지 잠금 해제 (2km, 5km, 10km)
- ✅ 실시간 진행 상황 표시 (Progress Bar)
- ✅ 30초마다 자동 동기화

### UI/UX
- ✅ Material Design 3 적용
- ✅ 퍼즐 목록 화면 + 걸음 수 보상 카드
- ✅ 내 정보 통계 화면
- ✅ 하단 네비게이션 바
- ✅ 다크/라이트 테마 지원
- ✅ 다국어 지원 (한국어, English)
  - 설정 화면에서 언어 전환 가능
  - 게임 플레이 화면 전체 번역 완료
  - 앱스토어 글로벌 출시 준비

### Developer Identity
- ✅ lukaPlayground 브랜딩
- ✅ WalkingPuzzle 로고
- ✅ 이스터에그: 설정 화면에서 버전 7번 탭 시 개발자 정보 표시

---

## 🔜 다음 단계

### 1. 앱스토어 등록 준비
- [ ] 앱 아이콘 최종 디자인
- [ ] 스크린샷 제작 (한국어/영어)
- [ ] 앱 설명 작성 (한국어/영어)
- [ ] 개인정보 처리방침 작성
- [ ] Apple Developer 계정 등록 ($99/년)
- [ ] TestFlight 베타 테스트

### 2. 위치 기반 특별 보상
- [ ] 백그라운드 GPS 감지 및 로컬 알림
- [ ] 랜드마크 근처 도달 시 자동 보상
- [ ] 실제 기기에서 GPS 테스트

### 3. 실제 기기 테스트 및 최적화
- [ ] iOS 실기기에서 HealthKit 연동 검증
- [ ] Android 실기기에서 Health Connect 검증
- [ ] 배터리 소모 최적화
- [ ] 걸음 수 동기화 주기 조정

### 4. 사용자 경험 개선
- [ ] 일일 목표 및 배지 시스템
- [ ] 통계 화면 강화
- [ ] 추가 퍼즐 타입 개발

---

## 🎯 프로젝트 목표

1. **건강한 습관 형성**: 게임을 즐기면서 자연스럽게 운동 동기 부여
2. **광고 없는 경험**: 순수하게 게임에만 집중할 수 있는 환경
3. **접근성**: 색약 모드, 다국어 지원, 직관적인 UI로 모두가 즐길 수 있는 게임
4. **글로벌 출시**: 한국어와 영어를 지원하여 해외 시장 진출
5. **탐험 요소**: 위치 기반 콘텐츠로 외출 동기 부여

---

## 📝 개발 로그

자세한 개발 과정 및 기술적 세부사항은 [CLAUDE.md](./CLAUDE.md)를 참고하세요.

---

## 📚 참고 자료

- [프로젝트 기획 및 목적](https://lukaplayground.tistory.com/2)
- [기술 스택 및 구현 세부사항](https://lukaplayground.tistory.com/3)

---

## 🤝 기여하기

이 프로젝트는 개인 프로젝트이지만, 피드백과 제안은 언제나 환영합니다!

- 이슈 등록: [GitHub Issues](https://github.com/lukaPlayground/walking-puzzle-game/issues)
- 개선 제안 또는 버그 제보

---

## 📄 라이선스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.

---

## 📧 연락처

- **개발자**: Luka Playground
- **GitHub**: [@lukaPlayground](https://github.com/lukaPlayground)
- **블로그**: [lukaplayground.tistory.com](https://lukaplayground.tistory.com)

---

**Made with ❤️ and 🚶‍♂️ by Luka Playground**
