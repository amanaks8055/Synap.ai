import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  int totalChecked = 0;
  int missingPrice = 0;
  int missingTips = 0;
  int missingFree = 0;
  int missingLogo = 0;
  Map<String, List<String>> nameMap = {};
  int duplicates = 0;
  bool hasMore = true;
  int offset = 0;
  const int limit = 1000;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,paid_price_monthly,paid_tier_description,optimization_tips,free_limit_description,icon_url&order=id&offset=$offset&limit=$limit';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      final List<dynamic> batch = jsonDecode(body);
      if (batch.isEmpty) {
        hasMore = false;
        break;
      }
      totalChecked += batch.length;
      offset += batch.length;

      for (var tool in batch) {
        bool priceMissing = (tool['paid_price_monthly'] == null && tool['paid_tier_description'] == null);
        bool tipsMissing = (tool['optimization_tips'] == null || tool['optimization_tips'].toString().isEmpty);
        bool freeMissing = (tool['free_limit_description'] == null || tool['free_limit_description'].toString().isEmpty);
        bool logoMissing = (tool['icon_url'] == null || tool['icon_url'].toString().isEmpty || tool['icon_url'].toString() == 'null');

        if (priceMissing) missingPrice++;
        if (tipsMissing) missingTips++;
        if (freeMissing) missingFree++;
        if (logoMissing) missingLogo++;
        
        String name = tool['name'].toString().trim().toLowerCase();
        if (nameMap.containsKey(name)) {
          nameMap[name]!.add(tool['id'].toString());
          duplicates++;
        } else {
          nameMap[name] = [tool['id'].toString()];
        }
      }
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }

  print('TOTAL_TOOLS: $totalChecked');
  print('MISSING_PRICE: $missingPrice');
  print('MISSING_TIPS: $missingTips');
  print('MISSING_FREE: $missingFree');
  print('MISSING_LOGO: $missingLogo');
  print('DUPLICATES: $duplicates');

  if (duplicates > 0) {
    var dupsList = nameMap.entries.where((e) => e.value.length > 1).toList();
    print('DUPLICATE_NAMES_COUNT: ${dupsList.length}');
  }

  client.close();
}
