import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('bin/quality_analysis_report.json');
  if (!file.existsSync()) {
    print('Report not found');
    return;
  }
  final data = jsonDecode(file.readAsStringSync());
  print('TOTAL_TOOLS: ${data["total_count"]}');
  print('DUPLICATES_NAME: ${data["duplicates_by_name_count"]}');
  print('DUPLICATES_URL: ${data["duplicates_by_url_count"]}');
  print('MISSING_LOGOS: ${data["missing_logo_count"]}');
}
