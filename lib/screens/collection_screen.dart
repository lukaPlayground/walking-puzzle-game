import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('랜드마크 컬렉션'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          final landmarksByCountry = locationProvider.getLandmarksByCountry();
          final collection = locationProvider.collection;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 수집 통계 카드
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '수집 현황',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            Icons.place,
                            '랜드마크',
                            '${collection.collectedLandmarkIds.length}',
                            Colors.blue,
                          ),
                          _buildStatItem(
                            context,
                            Icons.flag,
                            '국가',
                            '${collection.collectedCountryCodes.length}',
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 국가별 랜드마크 목록
              ...landmarksByCountry.entries.map((entry) {
                final countryCode = entry.key;
                final landmarks = entry.value;
                final countryName = landmarks.first.country;
                final countryFlag = locationProvider.getCountryFlag(countryCode);
                final hasCountry = collection.hasCountry(countryCode);
                final collectedCount = landmarks
                    .where((l) => collection.hasLandmark(l.id))
                    .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            countryFlag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  countryName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '$collectedCount / ${landmarks.length} 수집',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (hasCountry)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '완료',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: landmarks.length,
                      itemBuilder: (context, index) {
                        final landmark = landmarks[index];
                        final isCollected =
                            collection.hasLandmark(landmark.id);

                        return Card(
                          elevation: isCollected ? 4 : 1,
                          color: isCollected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.grey[300],
                          child: InkWell(
                            onTap: () {
                              _showLandmarkDetail(context, landmark, isCollected);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  landmark.icon,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: isCollected ? null : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  landmark.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isCollected ? null : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  void _showLandmarkDetail(
    BuildContext context,
    dynamic landmark,
    bool isCollected,
  ) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final isCurrentProfile = locationProvider.collection.selectedProfileIcon == landmark.id;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(landmark.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 8),
            Expanded(child: Text(landmark.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(landmark.description),
            const SizedBox(height: 16),
            if (isCollected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      '수집 완료',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      '아직 방문하지 않음',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (isCollected && isCurrentProfile)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        '현재 프로필 아이콘',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (isCollected && !isCurrentProfile)
            TextButton(
              onPressed: () async {
                await locationProvider.setProfileIcon(landmark.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${landmark.icon} ${landmark.name}을(를) 프로필 아이콘으로 설정했습니다'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('프로필 아이콘으로 설정'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
