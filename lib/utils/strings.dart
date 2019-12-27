class Strings {
  static bool containsLowerCase(String text, String value) => text
      .toLowerCase()
      .contains(value.toLowerCase());
}