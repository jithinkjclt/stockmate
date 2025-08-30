import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';

class UserService {
  static const String _idTokenKey = "id_token";
  static const String _nameKey = "user_name";
  static const String _emailKey = "user_email";

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, user.name);
    await prefs.setString(_emailKey, user.email);
    await prefs.setString(_idTokenKey, user.idToken);
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(_nameKey);
    final email = prefs.getString(_emailKey);
    final idToken = prefs.getString(_idTokenKey);

    if (name != null && email != null && idToken != null) {
      return UserModel(name: name, email: email, idToken: idToken);
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_idTokenKey);
  }

  Future<void> printUser() async {
    final prefs = await SharedPreferences.getInstance();
    print("Name: ${prefs.getString(_nameKey)}");
    print("Email: ${prefs.getString(_emailKey)}");
    print("Id Token: ${prefs.getString(_idTokenKey)}");
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_idTokenKey) &&
        prefs.containsKey(_emailKey) &&
        prefs.containsKey(_nameKey);
  }
}
