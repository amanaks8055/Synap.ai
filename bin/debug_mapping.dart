import 'dart:convert';
import 'dart:io';

void main() async {
  final existingIdsFile = File('bin/existing_ids.json');
  final Set<String> existingIds = Set.from(jsonDecode(existingIdsFile.readAsStringSync()));
  print('Existing IDs: ${existingIds.length}');

  final githubFile = File('bin/AIToolsList.json');
  final List<dynamic> githubTools = jsonDecode(githubFile.readAsStringSync());
  print('GitHub Tools: ${githubTools.length}');

  int matches = 0;
  for (var gt in githubTools) {
    if (existingIds.contains(gt['handle'])) {
      matches++;
    }
  }
  print('Matches: $matches');
  print('New tools available: ${githubTools.length - matches}');
}
