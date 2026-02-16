/// (“hello world flutter dev” → “Hello World Flutter Dev”)
extension StringExtensions on String {
  String capitalizeEachWord() {
    if (trim().isEmpty) return this;

    return split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

/// (“hello world” → “Hello world”)
extension CapitalizeFirst on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

/// (“HELLO WORLD” → “Hello world”)
extension SentenceCase on String {
  String toSentenceCase() {
    if (isEmpty) return this;
    final lower = toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}

/// (“ hello world ” → “hello world”)
extension CleanSpaces on String {
  String removeExtraSpaces() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}

/// (“hello_world_test” → “Hello World Test”)
extension SnakeCase on String {
  String fromSnakeCase() {
    return replaceAll('_', ' ').capitalizeEachWord();
  }
}

/// (“helloWorldTest” → “Hello World Test”)
extension CamelCase on String {
  String fromCamelCase() {
    return replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => "${match.group(1)} ${match.group(2)}",
    ).capitalizeEachWord();
  }
}

/// (Useful for cleaning usernames)
extension CleanAlphanumeric on String {
  String onlyAlphanumeric() {
    return replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }
}

/// (“Hello world”, 5 → “Hello…”)
extension TruncateText on String {
  String truncate(int max, {String suffix = "..."}) {
    if (length <= max) return this;
    return substring(0, max) + suffix;
  }
}
