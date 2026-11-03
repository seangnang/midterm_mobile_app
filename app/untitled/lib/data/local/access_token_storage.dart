import 'package:get_storage/get_storage.dart';

class AccessTokenStorage {
  final _storage = GetStorage();
  final _accessToken = "ACCESS TOKEN";
  final _refreshToken = "REFRESH_TOKEN";

  void saveToken({String? token, String? refreshToken}){
    _storage.write(_accessToken, token);
    _storage.write(_refreshToken, token);
  }
  String getAccess ()=> _storage.read(_accessToken);
  String getRefreshAccess ()=> _storage.read(_refreshToken);
  void removeToken() {
    _storage.remove(_accessToken);
    _storage.remove(_refreshToken);
  }
}