import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,description&paid_price_monthly=is.null&limit=50';
  
  try {
    final req = await client.getUrl(Uri.parse(queryUrl));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final List<dynamic> data = jsonDecode(body);
    
    print('SAMPLE MISSING DATA TOOLS:');
    for (var tool in data) {
      print('- ${tool['name']} (${tool['id']})');
    }
  } catch (e) {
    print('ERR: $e');
  }
  client.close();
}
