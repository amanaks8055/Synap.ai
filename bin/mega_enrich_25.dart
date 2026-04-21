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
    t('whimsical-ai', freeTier:'Free forever for up to 3 boards', price:10, priceTier:'Pro monthly annual', tips:'The world leader in visual workspace | AI-powered "Mind Maps" and "Flowcharts" generate entire systems from a single prompt in seconds'),
    t('figjam-ai', freeTier:'Free part of Figma basic account', price:0, tips:'Figma\'s official whiteboarding tool | AI-powered "Generate" and "Sort" helps teams brainstorm, organize stickies, and build templates instantly'),
    t('adept-ai', freeTier:'Waitlist/Institutional during beta', price:0, tips:'The pioneer of AI that "does" things | Best for automating complex browser-based workflows across any software using natural language'),
    t('phantombuster', freeTier:'14-day free trial on site', price:48, priceTier:'Starter monthly annual', tips:'Leading platform for automated data extraction and outreach | AI-powered "Sales" and "LinkedIn" workflows for massive lead generation data'),
    t('clay', freeTier:'Free trial for 1000 items', price:149, priceTier:'Starter monthly starting', tips:'The world\'s most powerful CRM for sales teams | AI-powered "Enrichment" and "Waterfall" data flows finds lead info from 50+ providers instantly'),
    t('eraser-io', freeTier:'Free forever basic version', price:12, priceTier:'Professional monthly annual', tips:'Leading "Design-to-code" tool for engineers | AI-powered "Diagram" and "Doc" generation helps architectural planning with deep data accuracy'),
    t('axiom-ai', freeTier:'Free for up to 2 hours of runtime', price:45, priceTier:'Lite monthly annual', tips:'The "Power-user" browser automation extension | AI-powered "No-code" scraper and data entry used by top growth hackers'),
    t('clockwise', freeTier:'Free forever basic version for pro users', price:7, priceTier:'Teams monthly annual', tips:'Leading AI smart calendar for individuals and teams | AI-powered "Focus Time" and "Flexible Meetings" automatically optimizes your schedule data'),
    t('mindmup', freeTier:'Free forever basic version online', price:3, priceTier:'Gold monthly per user', tips:'Best for building massive mind maps and brainstorms | AI-powered "Hierarchy" and "Data" management used by academics and planners'),
    t('ocoya', freeTier:'7-day free trial on site', price:15, priceTier:'Silver monthly annual', tips:'The "All-in-one" social media platform | AI-powered "Travis" assistant creates posts, designs, and captions across 10+ platforms instantly'),
    t('deckrobot', freeTier:'Institutional only', price:0, tips:'Leading AI for PowerPoint automation | Best for consultants turning rough sketches and data into high-end professional slides automatically'),
    t('figjam-ai-pro', freeTier:'Free basic access (Figma)', price:0, tips:'The ultimate brainstorming assistant | AI-powered "Research" and "Ideation" tools used by world-class design teams'),
    t('whimsical-pro', freeTier:'Free basic boards', price:10, priceTier:'Pro monthly', tips:'High-end visual system planning | AI-powered "AI Mind Maps" helps founders map out complete product architectures in one click'),
    t('phantom-buster-ai', freeTier:'Free trial access', price:48, priceTier:'Starter monthly', tips:'The automation powerhouse for your browser | Use the "AI LinkedIn" scraper to build massive lead databases without technical coding'),
    t('clay-ai-pro', freeTier:'Free account trial', price:149, priceTier:'Starter monthly', tips:'The smartest CRM on the planet | AI-powered "Research" on your prospects is extremely deep and handles all lead data validation'),
    t('eraser-io-pro', freeTier:'Free basic version', price:12, priceTier:'Pro monthly', tips:'The documentation tool for pro engineers | AI-powered "Cloud Architecture" diagrams from text briefs'),
    t('axiom-ai-pro', freeTier:'Free runtime trial', price:45, priceTier:'Lite monthly', tips:'The "Auto-GPT" for web scraping | Best for repetitive browser tasks and data formatting without building custom bots'),
    t('clockwise-ai-pro', freeTier:'Free basic version', price:7, priceTier:'Premium monthly', tips:'The intelligent calendar assistant | AI-powered "Conflict" resolution and meeting data tracking for high-performance teams'),
    t('mind-mup-ai', freeTier:'Free basic mapping', price:3, priceTier:'Gold monthly', tips:'High-speed brainstorm and diagram tool | Best for organizing complex thoughts and large data hierarchies visually'),
    t('ocoya-ai-pro', freeTier:'Free social trial', price:15, priceTier:'Silver monthly', tips:'Leading platform for automated social marketing | AI-powered "Image" and "Copy" generation handles all your brand data'),
    t('oscopilot', freeTier:'Completely free open source', price:0, tips:'Leading autonomous agent for your operating system | Best for developers building AI assistants that can use any app on your desktop'),
    t('adept-ai-pro', freeTier:'Institutional waitlist', price:0, tips:'The future of human-computer interaction | AI-powered "Action" engine executes complex tasks across various softwares using data'),
    t('deck-robot-ai', freeTier:'Institutional only', price:0, tips:'The master of professional slides | AI-powered "Layout" and "Design" consistency for enterprise consulting data'),
    t('axiom-pro', freeTier:'Free trial runtime', price:45, priceTier:'Monthly subscription', tips:'The "No-code" scraper for pro builders | AI-powered "Extraction" handles even the most complex web data flows'),
    t('fig-jam', freeTier:'Free for personal (Figma)', price:0, tips:'The smartest way to run retros and brainstorming sessions | AI-powered "Sticky" grouping saves hours of data organizing'),
    t('phantom-buster', freeTier:'Free trial available', price:48, priceTier:'Lite monthly', tips:'The ultimate tool for growth hackers | AI-powered "Cloud" automations for LinkedIn, Twitter, and Facebook data'),
    t('clockwise-pro', freeTier:'Free trial available', price:7, priceTier:'Teams monthly', tips:'The calendar that works for YOU | AI-powered "Schedule" optimization used by teams at Netflix and Twitter'),
    t('mindmup-pro', freeTier:'Free basic version', price:3, priceTier:'Gold monthly', tips:'Professional mind mapping and planning | AI-powered "Export" handles PDF and Image data perfectly for reports'),
    t('ocoya-pro', freeTier:'Free trial available', price:15, priceTier:'Silver monthly', tips:'High-speed content automation suite | AI-powered "Analytics" helps you understand what content drives data results'),
    t('axiom', freeTier:'Free runtime daily', price:45, priceTier:'Lite monthly', tips:'The browser assistant for busy teams | Build automated data entry and scraping flows in minutes with AI help'),
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
