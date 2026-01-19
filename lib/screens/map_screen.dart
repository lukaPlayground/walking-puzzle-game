import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          final location = locationProvider.currentLocation;
          final landmarks = locationProvider.landmarks;

          return Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Google Maps 통합 예정',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (location != null)
                          Text(
                            '현재 위치:\n위도 ${location.latitude.toStringAsFixed(4)}\n경도 ${location.longitude.toStringAsFixed(4)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: landmarks.length,
                  itemBuilder: (context, index) {
                    final landmark = landmarks[index];
                    final distance = location != null
                        ? locationProvider.getDistanceToLandmark(landmark.id)
                        : null;
                    final isNearby = location != null && landmark.isUserNearby(location);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isNearby ? Colors.green : Colors.blue[100],
                        child: Icon(
                          isNearby ? Icons.check_circle : Icons.place,
                          color: isNearby ? Colors.white : Colors.blue,
                        ),
                      ),
                      title: Text(
                        landmark.name,
                        style: TextStyle(
                          fontWeight: isNearby ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(landmark.description),
                      trailing: distance != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  distance < 1000
                                      ? '${distance.toStringAsFixed(0)}m'
                                      : '${(distance / 1000).toStringAsFixed(1)}km',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isNearby ? Colors.green : null,
                                  ),
                                ),
                                if (isNearby)
                                  Text(
                                    '근처!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
