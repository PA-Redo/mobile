import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StayLoginSecureStorage {
  factory StayLoginSecureStorage() => _instance;

  StayLoginSecureStorage._internal();

  static final StayLoginSecureStorage _instance = StayLoginSecureStorage._internal();

  final String STAY_LOGIN = 'stay_login';

  final String IS_Volunteer = 'is_volunteer';

  Future<void> stayLogin() async {
    await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).write(key: STAY_LOGIN, value: 'true');
  }

  Future<void> notStayLogin() async {
    await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).write(key: STAY_LOGIN, value: 'false');
  }

  Future<bool> readStayLogin() async {
    return await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).read(key: STAY_LOGIN) == 'true';
  }

  Future<void> isVolunteer() async {
    await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).write(key: IS_Volunteer, value: 'true');
  }

  Future<void> notVolunteer() async {
    await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).write(key: IS_Volunteer, value: 'false');
  }

  Future<bool> readIsVolunteer() async {
    return await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).read(key: IS_Volunteer) == 'true';
  }
}
