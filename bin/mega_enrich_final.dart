// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

Map<String, dynamic> t(String id, {String? freeTier, double? price, String? priceTier, String? tips}) {
  return {
    'id': id,
    'has_free_tier': freeTier != null,
    'free_limit_description': freeTier,
    'paid_price_monthly': price,
    'paid_tier_description': priceTier,
    'optimization_tips': tips,
  };
}

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('where-to-buy', freeTier: 'Completely free (Google Lens)', price: 0, tips: 'Google Lens\'s official fashion and shopping discovery tool | AI-powered "Visual Search" and "Style Match" help users find where to buy any clothing item or accessory from a photo and manage their personal fashion data logs instantly'),
    t('zyro-ai', freeTier: 'Free trial available for logo/copy', price: 2.90, priceTier: 'Website monthly annual', tips: 'Hostinger\'s official AI-powered website builder | AI-powered "Heatmap," "Logo Maker," and "AI Writer" help small businesses build high-fidelity websites and manage their entire brand data presence in seconds'),
    t('where-to-buy-pro', freeTier: 'Free for all users', price: 0, tips: 'Technical fashion assistant for pro shoppers | AI-powered "Price Comparison" and "Inventory Check" handles your entire shopping data discovery flow and store mapping automatically using Google\'s high-end search logs'),
    t('zyro-ai-pro', freeTier: 'Free trial available', price: 2.90, priceTier: 'Professional monthly', tips: 'Professional website orchestration suite | Featuring high-end "E-commerce Support" and "AI Marketing Tools" to ensure your entire online business follows specific brand and data benchmarks'),
  ];

  print('Total tools to enrich: ${tools.length}');

  for (var tool in tools) {
    String id = tool.remove('id');
    final supaPath = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    final bodyBytes = utf8.encode(jsonEncode(tool));

    try {
      final req = await client.patchUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('OK: $id');
      } else {
        print('FAIL: $id [${resp.statusCode}]');
      }
    } catch (e) {
      print('ERR: $id - $e');
    }
  }

  client.close();
}
