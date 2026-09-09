import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String tokenKey = "token";
  static const String studentIdKey = "student_id";
  static const String userName = "user_name";


  //================ Save =================//

  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: tokenKey,
      value: token,
    );
  }

  //================ Read =================//

  static Future<String?> getToken() async {
    return await _storage.read(
      key: tokenKey,
    );
  }

  //================ Delete =================//

  static Future<void> deleteToken() async {
    await _storage.delete(
      key: tokenKey,
    );
  }

  //================ Delete All =================//

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  //================ Save =================//

  static Future<void> saveStudentId(int studentId) async {
    await _storage.write(
      key: studentIdKey,
      value: studentId.toString(),
    );
  }

//================ Read =================//

  static Future<int> getStudentId() async {
    final id = await _storage.read(key: studentIdKey);

    return int.parse(id!);
  }


  static Future<void> saveUserName(String userName) async {
    await _storage.write(
      key: userName,
      value: userName,
    );
  }

//================ Read =================//

  static Future<String?> getUserName() async {
    return await _storage.read(
      key: userName,
    );
  }

//================ Delete =================//

  static Future<void> deleteStudentId() async {
    await _storage.delete(
      key: studentIdKey,
    );
  }

//================ Theme mode =================//

  static const String themeModeKey = "theme_mode";

  static Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: themeModeKey, value: mode);
  }

  static Future<String?> getThemeMode() async {
    return await _storage.read(key: themeModeKey);
  }
}
