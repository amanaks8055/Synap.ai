// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

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
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('scale-ai', freeTier:'Free trial for data labeling basic', price:0, tips:'The world leader in data for AI | Features world-class "Reinforcement Learning from Human Feedback" (RLHF) and high-quality data labeling used by OpenAI and Meta'),
    t('riskified', freeTier:'Institutional only', price:0, tips:'Leading AI for fraud prevention and chargeback protection | AI-powered "Decisioning" engine used by global e-commerce giants to maximize revenue and data safety'),
    t('sift-science', freeTier:'Free trial for 30 days on site', price:0, tips:'Leading platform for Digital Trust & Safety | AI-powered "Behavioral" data modeling stops account takeovers and payment fraud at massive scale'),
    t('skyflow-ai', freeTier:'Free trial available on site', price:0, tips:'The "Data Privacy Vault" for modern apps | AI-powered "Redaction" and "Tokenization" handles PII and sensitive data securely for healthcare and finance'),
    t('nightfall-ai', freeTier:'Free trial for up to 100 scans', price:0, tips:'Leading AI for Data Loss Prevention (DLP) | AI-powered "Sensitive Data" discovery finds and masks secrets in Slack, GitHub, and Jira automatically using deep research data'),
    t('securiti', freeTier:'Institutional only', price:0, tips:'Leading platform for unified Data Command Center | AI-powered "Privacy" and "Governance" handles millions of data points across multi-cloud environments'),
    t('verisoul', freeTier:'Free trial for 1000 users', price:0, tips:'Leading AI for bot and fake account detection | Best for protecting social apps and marketplaces from automated data attacks and sybil actors'),
    t('kount-ai', freeTier:'Institutional only (Equifax)', price:0, tips:'Leading AI for identity and payment fraud prevention | Features world-class "Identity Trust Global Network" driven by billions of historical data points'),
    t('sardine-ai', freeTier:'Free trial available on site', price:0, tips:'The "Safety First" platform for FinTech and Crypto | AI-powered "Compliance" and "Fraud" detection used by world-class financial data teams'),
    t('riskified-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional fraud management suite | AI-powered "Chargeback Guarantee" handles your entire e-commerce data protection cycle'),
    t('scale-ai-pro', freeTier:'Free dev trial', price:0, tips:'The elite platform for generative AI training | Features incredible "LLM Engine" and high-end data curation used by top tech companies globally'),
    t('sky-flow-ai', freeTier:'Free trial available', price:0, tips:'The industry standard for sensitive data isolation | AI-powered "Vault" helps you follow GDPR and HIPAA data guidelines effortlessly'),
    t('nightfall-pro', freeTier:'Free basic scans', price:0, tips:'Enterprise-grade data protection suite | AI-powered "Real-time" detection stops data leaks across your entire dev surface area'),
    t('securiti-ai-pro', freeTier:'Institutional only', price:0, tips:'The choice of Global 2000 companies | AI-powered "Discovery" handles thousands of cloud data sources for privacy and risk reports'),
    t('verisoul-ai', freeTier:'Free basic tracker', price:0, tips:'Next-gen bot prevention engine | AI-powered "Device Fingerprinting" driven by millions of behavioral data points for high-end security'),
    t('kount-pro', freeTier:'Institutional only', price:0, tips:'High-end identity and risk management platform | AI-powered "Score" handles your entire customer verification data flow'),
    t('sardine-pro', freeTier:'Free trial available', price:0, tips:'The choices of top crypto exchanges | AI-powered "KYC" and "AML" automation handles your entire high-speed financial data cycle'),
    t('sift-pro', freeTier:'Free trial available', price:0, tips:'Professional trust and safety suite | AI-powered "Automation" handles thousands of risky data accounts simultaneously for massive web platforms'),
    t('scale', freeTier:'Free basic assets', price:0, tips:'The "Infrastructure" of AI | Use the "Data Curation" tool to find and fix errors in your training data sets with AI intelligence'),
    t('riskified-pro', freeTier:'Institutional only', price:0, tips:'The master of e-com growth | AI-powered "Insight" reports handles your public image data across high-end retail channels'),
    t('skyflow-pro', freeTier:'Free trial available', price:0, tips:'The smarter way to build secure apps | AI-powered "API" for sensitive data isolation used by top healthcare data scientists'),
    t('nightfall-ai-dlp', freeTier:'Free basic account', price:0, tips:'The power-user tool for cloud security | Features world-class "Automated" remediation for sensitive data exposure in pro teams'),
    t('securiti-pro', freeTier:'Institutional only', price:0, tips:'The "Command Center" for data privacy | AI-powered "Governance" ensures your entire team follows specific compliance data benchmarks'),
    t('verisoul-pro', freeTier:'Free trial access', price:0, tips:'Advanced user verification suite | AI-powered "Bot" discovery finds and blocks even the most complex automated data actors'),
    t('kount-ai-fraud', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end payment security | AI-powered "Decisioning" used by top retailers to protect their transactional data'),
    t('sardine-ai-fraud', freeTier:'Free trial available', price:0, tips:'The industry standard for fintech security | AI-powered "Identity" verification driven by real-time behavioral data scores'),
    t('sift-ai-security', freeTier:'Free trial available', price:0, tips:'Next-gen cyber defense for marketplaces | AI-powered "Policy" management handles your entire team\'s data trust scores automatically'),
    t('scale-engine', freeTier:'Free trial for dev', price:0, tips:'The expert choice for building models from scratch | Featuring high-end "Synthetic Data" generation for edge case training'),
    t('sky-flow-pro', freeTier:'Free trial available', price:0, tips:'Professional data vault for enterprises | AI-powered "Encryption" handles thousands of sensitive fields simultaneously for your reports'),
    t('night-fall-pro', freeTier:'Free trial available', price:0, tips:'The choice of top security teams | AI-powered "Alerting" handles thousands of production data streams for model health and privacy'),
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
