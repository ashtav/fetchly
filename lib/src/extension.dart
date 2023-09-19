part of fetch;

extension DioCustomExtension on Dio {
  void setToken(String? token, {String? prefix}) {
    dio.options.headers['authorization'] =
        prefix == null ? 'Bearer $token' : '$prefix $token';
  }

  int get logLimit => 2000;
}
