import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/step_counter_provider.dart';
import 'providers/location_provider.dart';

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
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    final gameProvider = context.read<GameProvider>();
    final stepCounterProvider = context.read<StepCounterProvider>();
    final locationProvider = context.read<LocationProvider>();

    await Future.wait([
      gameProvider.initialize(),
      stepCounterProvider.initialize(),
      locationProvider.initialize(),
    ]);

    stepCounterProvider.startTracking();
    locationProvider.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walking Puzzle Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<StepCounterProvider>(
              builder: (context, stepProvider, child) {
                return Column(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '오늘의 걸음 수',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stepProvider.todaySteps}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stepProvider.todayDistanceKm.toStringAsFixed(2)} km',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                final location = locationProvider.currentLocation;
                return Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 40,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location != null
                          ? '위치: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'
                          : '위치 정보를 가져오는 중...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                final progress = gameProvider.userProgress;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '게임 진행 상황',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '잠금 해제',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '${progress?.unlockedPuzzles.length ?? 0}',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '완료',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '${progress?.completedPuzzles.length ?? 0}',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '힌트',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '${progress?.availableHints ?? 0}',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
