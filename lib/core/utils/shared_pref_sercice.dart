import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefSercice {
  static final SharedPrefSercice _instance = SharedPrefSercice._internal();

  late SharedPreferences _sharedPreferences;

  factory SharedPrefSercice() => _instance;

  SharedPrefSercice._internal();

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setValue(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (String):
        return await _sharedPreferences.setString(key, value);
      case const (int):
        return await _sharedPreferences.setInt(key, value);
      case const (bool):
        return await _sharedPreferences.setBool(key, value);
      case const (double):
        return await _sharedPreferences.setDouble(key, value);
      case const (List<String>):
        return await _sharedPreferences.setStringList(key, value);
    }
    return false;
  }

  dynamic getValue(String key, dynamic defaultValue) {
    switch (defaultValue.runtimeType) {
      case const (String):
        return _sharedPreferences.getString(key) ?? defaultValue;
      case const (int):
        return _sharedPreferences.getInt(key) ?? defaultValue;
      case const (bool):
        return _sharedPreferences.getBool(key) ?? defaultValue;
      case const (double):
        return _sharedPreferences.getDouble(key) ?? defaultValue;
      case const (List<String>):
        return _sharedPreferences.getStringList(key) ?? defaultValue;
    }
    return defaultValue;
  }

  Future<bool?> deleteKey(String key) async {
    return _sharedPreferences.remove(key);
  }
}
