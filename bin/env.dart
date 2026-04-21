import 'dart:io';

class Env {
  Env._();

  static final Map<String, String> _fileValues = _loadDotEnvFile();

  static String? get(String key) {
    final fromPlatform = Platform.environment[key];
    if (fromPlatform != null && fromPlatform.isNotEmpty) return fromPlatform;
    return _fileValues[key];
  }

  static String require(String key) {
    final value = get(key);
    if (value == null || value.trim().isEmpty) {
      throw StateError(
        'Missing env var "$key". Add it to .env (repo root) or set it in your shell environment.',
      );
    }
    return value;
  }

  static String get supabaseUrl => require('SUPABASE_URL');
  static String get supabaseAnonKey => require('SUPABASE_ANON_KEY');

  static Map<String, String> _loadDotEnvFile() {
    final file = File('.env');
    if (!file.existsSync()) return <String, String>{};

    final values = <String, String>{};
    for (final rawLine in file.readAsLinesSync()) {
      var line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      if (line.startsWith('export ')) {
        line = line.substring('export '.length).trim();
      }

      final eq = line.indexOf('=');
      if (eq <= 0) continue;

      final key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();

      if (value.length >= 2) {
        final first = value[0];
        final last = value[value.length - 1];
        if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
          value = value.substring(1, value.length - 1);
        }
      }

      values[key] = value;
    }

    return values;
  }
}
