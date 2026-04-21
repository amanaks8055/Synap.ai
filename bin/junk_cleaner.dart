import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final idsToDelete = ['check_rls'];

  for (var id in idsToDelete) {
    final deleteUrl = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    try {
      final req = await client.deleteUrl(Uri.parse(deleteUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('Deleted junk: $id');
      } else {
        print('Failed to delete $id: Status ${resp.statusCode}');
      }
    } catch (e) {
      print('ERR: $e');
    }
  }
  client.close();
}
