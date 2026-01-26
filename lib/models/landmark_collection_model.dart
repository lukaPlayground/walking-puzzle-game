class LandmarkCollectionModel {
  final Set<String> collectedLandmarkIds;
  final Set<String> collectedCountryCodes;
  final Set<String> viewedLandmarkIds; // 이미 확인한 랜드마크 (알림 뱃지 제어용)
  final String? selectedProfileIcon; // 선택한 프로필 아이콘 (랜드마크 ID)

  LandmarkCollectionModel({
    Set<String>? collectedLandmarkIds,
    Set<String>? collectedCountryCodes,
    Set<String>? viewedLandmarkIds,
    this.selectedProfileIcon,
  })  : collectedLandmarkIds = collectedLandmarkIds ?? {},
        collectedCountryCodes = collectedCountryCodes ?? {},
        viewedLandmarkIds = viewedLandmarkIds ?? {};

  factory LandmarkCollectionModel.fromJson(Map<String, dynamic> json) {
    return LandmarkCollectionModel(
      collectedLandmarkIds: (json['collectedLandmarkIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      collectedCountryCodes: (json['collectedCountryCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      viewedLandmarkIds: (json['viewedLandmarkIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {},
      selectedProfileIcon: json['selectedProfileIcon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectedLandmarkIds': collectedLandmarkIds.toList(),
      'collectedCountryCodes': collectedCountryCodes.toList(),
      'viewedLandmarkIds': viewedLandmarkIds.toList(),
      'selectedProfileIcon': selectedProfileIcon,
    };
  }

  bool hasLandmark(String landmarkId) {
    return collectedLandmarkIds.contains(landmarkId);
  }

  bool hasCountry(String countryCode) {
    return collectedCountryCodes.contains(countryCode);
  }

  int getUnviewedCount() {
    return collectedLandmarkIds.difference(viewedLandmarkIds).length;
  }

  LandmarkCollectionModel copyWith({
    Set<String>? collectedLandmarkIds,
    Set<String>? collectedCountryCodes,
    Set<String>? viewedLandmarkIds,
    String? selectedProfileIcon,
  }) {
    return LandmarkCollectionModel(
      collectedLandmarkIds: collectedLandmarkIds ?? this.collectedLandmarkIds,
      collectedCountryCodes:
          collectedCountryCodes ?? this.collectedCountryCodes,
      viewedLandmarkIds: viewedLandmarkIds ?? this.viewedLandmarkIds,
      selectedProfileIcon: selectedProfileIcon ?? this.selectedProfileIcon,
    );
  }
}
