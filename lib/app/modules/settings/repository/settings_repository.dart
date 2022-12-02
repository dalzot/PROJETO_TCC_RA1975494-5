import '../model/version_model.dart';

class SettingsRepository {
  SettingsRepository();

  Future<VersionModel> getVersion() async {
    return  VersionModel(status: 'Online', androidVersion: 1, iosVersion: 1);
//    final response = await _http.findLatestAppVersion();
//    if (response.statusCode == 200) {
//      return VersionModel.fromJson(response.data);
//    } else {
//      throw Exception('Failed to load version');
//    }
  }
}
