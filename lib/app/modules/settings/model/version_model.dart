class VersionModel {
  final String status;
  final int androidVersion;
  final int iosVersion;

  VersionModel({
    required this.status,
    required this.androidVersion,
    required this.iosVersion,
  });

  factory VersionModel.fromJson(Map<String, dynamic> map) => VersionModel(
    status: map['status'],
    androidVersion: int.tryParse(map['version']) ?? 0,
    iosVersion: int.tryParse(map['iosVersion']) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'version': androidVersion,
    'iosVersion': iosVersion,
  };

  VersionModel copyWith({
    String? status,
    int? androidVersion,
    int? iosVersion,
  }) {
    return VersionModel(
      status: status ?? this.status,
      androidVersion: androidVersion ?? this.androidVersion,
      iosVersion: iosVersion ?? this.iosVersion,
    );
  }

  @override
  String toString() {
    return 'VersionModel{status: $status, androidVersion: $androidVersion, iosVersion: $iosVersion}';
  }
}
