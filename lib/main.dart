import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/step_counter_provider.dart';
import 'providers/location_provider.dart';
import 'screens/puzzle_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const WalkingPuzzleApp());
}

class WalkingPuzzleApp extends StatelessWidget {
  const WalkingPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => StepCounterProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Walking Puzzle Game',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isInitializing = true;
  String _errorMessage = '';

  final List<Widget> _screens = const [
    PuzzleListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Provider들을 안전하게 가져오기 (mounted 체크 후)
      if (!mounted) return;

      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      final stepCounterProvider = Provider.of<StepCounterProvider>(context, listen: false);
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);

      // 모든 Provider 초기화
      await Future.wait([
        gameProvider.initialize(),
        stepCounterProvider.initialize(),
        locationProvider.initialize(),
      ]);

      // 추적 시작
      stepCounterProvider.startTracking();
      locationProvider.startTracking();

      // StepCounterProvider 리스너 추가: 걸음 수 변경 시 GameProvider에 자동 업데이트
      stepCounterProvider.addListener(() {
        gameProvider.updateSteps(
          stepCounterProvider.todaySteps,
          stepCounterProvider.totalSteps,
        );
      });

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = '초기화 중 오류 발생: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('앱을 초기화하는 중...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isInitializing = true;
                    _errorMessage = '';
                  });
                  _initializeApp();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension),
            label: '퍼즐',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}
