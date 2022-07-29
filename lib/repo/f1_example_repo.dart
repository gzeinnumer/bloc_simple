class ExampleRepo {
  Future<String> validate(String str) async {
    await Future.delayed(const Duration(seconds: 1));

    return str + str;
  }
}
