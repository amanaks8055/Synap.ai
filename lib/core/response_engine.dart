// lib/core/response_engine.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Rule-Based Response Engine
// Randomized pools, context-aware, follow-up handling
// ══════════════════════════════════════════════════════════════

import 'dart:math';
import 'context_manager.dart';

class ResponseResult {
  final String text;
  final bool showTools;   // should we also show tool cards?
  final String? toolQuery; // original query for tool lookup
  const ResponseResult(this.text, {this.showTools = false, this.toolQuery});
}

class ResponseEngine {
  static final _rng = Random();

  /// Generate a response based on intent + context
  static ResponseResult generate(
    String intent,
    String rawInput,
    ConversationContext ctx,
  ) {
    switch (intent) {
      case 'greeting':
        return _greeting(ctx);
      case 'how_are_you':
        return _howAreYou(ctx);
      case 'assistant_info':
        return _assistantInfo();
      case 'thanks':
        return _thanks();
      case 'goodbye':
        return _goodbye(ctx);
      case 'joke':
        return _joke();
      case 'time_date':
        return _timeDate();
      case 'motivation':
        return _motivation();
      case 'tip':
        return _tip();
      case 'tool_search':
        return _toolSearch(rawInput);
      case 'followup_free':
        return _followupFree(ctx);
      case 'followup_best':
        return _followupBest(ctx);
      case 'followup_beginner':
        return _followupBeginner(ctx);
      case 'followup_more':
        return _followupMore(ctx);
      case 'affirm':
        return _affirm(ctx);
      case 'deny':
        return _deny();
      case 'empty':
        return const ResponseResult(
          'I didn\'t catch that. Could you say it again?');
      default:
        return _fallback(ctx, rawInput);
    }
  }

  // ═══════════════════════════════════════════════════════
  // RESPONSE POOLS
  // ═══════════════════════════════════════════════════════

  static ResponseResult _greeting(ConversationContext ctx) {
    if (ctx.isFreshConversation) {
      return ResponseResult(_pick([
        'Hello! 👋 I\'m Synap AI — your personal AI tool guide. Ask me anything about free AI tools, or just chat!',
        'Hey there! 🚀 Welcome to Synap. I can help you discover the best free AI tools. What would you like to know?',
        'Hi! 😊 I\'m here to help you find amazing AI tools and answer questions. What\'s on your mind?',
        'Hello! Great to see you! I\'m your AI assistant — ask me about any tool, or let\'s just have a chat!',
      ]));
    }
    return ResponseResult(_pick([
      'Hey again! 👋 What else can I help with?',
      'Hello! Back for more? I\'m ready to help! 😄',
      'Hi! What would you like to explore next?',
    ]));
  }

  static ResponseResult _howAreYou(ConversationContext ctx) {
    return ResponseResult(_pick([
      'I\'m doing great, thanks for asking! 😊 I\'m always ready to help you find awesome AI tools. How about you?',
      'Running at 100%! ⚡ Ready to assist you with anything. What can I do for you today?',
      'I\'m excellent! Thanks for asking. 💪 Is there something I can help you with?',
      'Feeling fantastic! I\'ve been keeping up with all the latest AI tools. Want to know what\'s trending?',
      'I\'m great! Just here, ready to be your AI tool expert. What do you need help with?',
    ]));
  }

  static ResponseResult _assistantInfo() {
    return ResponseResult(_pick([
      'I\'m Synap AI — your personal guide to the world of AI tools! 🧠\n\nHere\'s what I can do:\n• 🔍 Find the best free AI tools for any task\n• 💡 Give productivity tips and advice\n• 📊 Track your AI tool usage\n• 💬 Chat naturally about anything\n\nJust ask me something like "best free video editor" or "help me code"!',
      'I\'m your AI assistant built into Synap! 🚀\n\nI help you:\n• Discover free AI tools for video, image, code, music & more\n• Get quick answers and recommendations\n• Track your daily AI tool usage\n\nNo internet AI needed — I work locally with smart rules! Try asking "what\'s the best coding tool?"',
    ]));
  }

  static ResponseResult _thanks() {
    return ResponseResult(_pick([
      'You\'re welcome! 😊 Happy to help anytime!',
      'Glad I could help! Let me know if you need anything else. 🙌',
      'No problem at all! That\'s what I\'m here for! ✨',
      'Anytime! Don\'t hesitate to ask more questions. 💪',
      'My pleasure! Feel free to come back whenever you need help! 😄',
    ]));
  }

  static ResponseResult _goodbye(ConversationContext ctx) {
    return ResponseResult(_pick([
      'Goodbye! 👋 Have an amazing day! Come back whenever you need help with AI tools.',
      'See you later! 🚀 Keep building awesome things!',
      'Bye! Take care and happy creating! ✨ I\'ll be here when you need me.',
      'Later! 😄 Remember, I\'m always here to help you discover great tools!',
      'Goodbye for now! May your productivity be legendary! 💪',
    ]));
  }

  static ResponseResult _joke() {
    return ResponseResult(_pick([
      '😄 Why did the AI go to school?\nBecause it wanted to improve its "learning rate"!',
      '🤖 What do you call an AI that sings?\nA-Dell-E! (DALL-E... get it?)',
      '😂 Why was the machine learning model bad at relationships?\nBecause it had too many "issues" with overfitting!',
      '🎭 An AI walks into a bar.\nThe bartender says, "What\'ll you have?"\nThe AI responds: "I\'ll have whatever you trained me on."',
      '😄 Why don\'t AI assistants ever get lost?\nBecause they always follow the gradient descent!',
      '🤣 What\'s an AI\'s favorite music?\nAlgo-rhythm!',
      '😂 Why did ChatGPT break up with Siri?\nBecause it found someone with a better context window!',
    ]));
  }

  static ResponseResult _timeDate() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

    String period = 'AM';
    int displayHour = hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        displayHour = hour - 12;
      }
    }
    if (displayHour == 0) {
      displayHour = 12;
    }

    final timeStr = '$displayHour:$minute $period';
    final dateStr = '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';

    String greeting = '';
    if (hour < 12) {
      greeting = 'Good morning! ☀️';
    } else if (hour < 17) {
      greeting = 'Good afternoon! 🌤️';
    } else {
      greeting = 'Good evening! 🌙';
    }

    return ResponseResult(
      '$greeting\n\n🕐 Current Time: $timeStr\n📅 Date: $dateStr'
    );
  }

  static ResponseResult _motivation() {
    return ResponseResult(_pick([
      '💪 "The only way to do great work is to love what you do." — Steve Jobs\n\nYou\'re on the right track. Keep pushing, keep building. Every small step counts!',
      '🚀 "Success is not final, failure is not fatal: it is the courage to continue that counts." — Winston Churchill\n\nKeep going — you\'re closer than you think!',
      '🔥 "The best time to start was yesterday. The second best time is NOW."\n\nDon\'t wait for perfection. Start building, start creating, start today!',
      '⚡ "Every expert was once a beginner." — Helen Hayes\n\nYou\'re learning, growing, and getting better every single day. That\'s what matters!',
      '🌟 "Believe you can and you\'re halfway there." — Theodore Roosevelt\n\nYour potential is limitless. Trust the process and keep moving forward!',
      '💎 "It\'s not about having time. It\'s about making time."\n\nPrioritize what matters. You have the same 24 hours as everyone else — make them count!',
    ]));
  }

  static ResponseResult _tip() {
    return ResponseResult(_pick([
      '💡 Pro Tip: Use Claude AI for long document analysis — it handles 200K tokens for free! Perfect for reading research papers or contracts.',
      '💡 Pro Tip: Gemini gives you 60 free queries daily and integrates with Google Search. Great for real-time research!',
      '💡 Pro Tip: Stack your free tiers! Use ChatGPT for brainstorming, Claude for writing, and Perplexity for research — all free!',
      '💡 Pro Tip: CapCut AI is 100% free for video editing with auto-captions. Perfect for creating Reels and Shorts!',
      '💡 Pro Tip: Microsoft Designer uses DALL-E 3 for FREE unlimited image generation. No credits needed!',
      '💡 Pro Tip: GitHub Copilot is free for students! Sign up with your .edu email and get AI coding assistance for free.',
      '💡 Pro Tip: Use Synap\'s tracker to monitor your free tier usage across tools — never hit a surprise limit again!',
    ]));
  }

  static ResponseResult _toolSearch(String rawInput) {
    return ResponseResult(
      '', // Response will be generated by VoiceKBService
      showTools: true,
      toolQuery: rawInput,
    );
  }

  // ═══════════════════════════════════════════════════════
  // FOLLOW-UP RESPONSES (Context-Aware)
  // ═══════════════════════════════════════════════════════

  static ResponseResult _followupFree(ConversationContext ctx) {
    if (!ctx.isFollowUp) {
      return const ResponseResult(
        'Which category are you looking for free tools in? Try saying "free video editing tool" or "free coding tool"!',
      );
    }

    final topic = ctx.topicDisplayName;
    final freeRecommendations = <String, String>{
      'video editing': '✅ CapCut AI is completely free — no watermarks, AI captions, and professional effects. Best free video editor available right now!',
      'image generation': '✅ Microsoft Designer uses DALL-E 3 for totally free image generation. Ideogram is also free with unlimited images!',
      'coding': '✅ Replit AI gives you a free cloud IDE with AI assistance. GitHub Copilot is free for students!',
      'music creation': '✅ Suno AI gives 50 free credits daily for full song generation including lyrics!',
      'AI assistants': '✅ Gemini is the most generous — 60 free queries/day. ChatGPT gives 40 messages every 3 hours!',
      'writing': '✅ Claude AI is best for free writing — 40 messages/day with excellent long-form capabilities!',
      'presentations': '✅ Canva AI has free presentation templates with AI design tools!',
      'career tools': '✅ Kickresume has a free AI resume builder with ATS-optimized templates!',
      'research': '✅ You.com offers unlimited free AI-powered search with source citations!',
      'voice tools': '✅ ElevenLabs gives 10,000 free characters/month with the most realistic AI voices!',
    };

    final response = freeRecommendations[topic];
    if (response != null) {
      return ResponseResult(response);
    }

    return ResponseResult(
      'For free $topic tools, let me show you the best options:',
      showTools: true,
      toolQuery: 'free $topic',
    );
  }

  static ResponseResult _followupBest(ConversationContext ctx) {
    if (!ctx.isFollowUp) {
      return const ResponseResult(
        'Best for which category? Try "best video editor" or "best AI for coding"!',
      );
    }

    final topic = ctx.topicDisplayName;
    final bestPicks = <String, String>{
      'video editing': '🏆 For professionals: Adobe Premiere Pro. For beginners: CapCut. For free power: DaVinci Resolve.',
      'image generation': '🏆 Best overall: Midjourney. Best free: Ideogram. Best for text in images: Adobe Firefly.',
      'coding': '🏆 Best AI code editor: Cursor AI. Best for VS Code: GitHub Copilot. Best free: Replit AI.',
      'music creation': '🏆 Best for full songs: Suno AI. Best quality: Udio. Best for background music: Soundraw.',
      'AI assistants': '🏆 Best all-rounder: ChatGPT. Best for writing: Claude. Best for research: Perplexity.',
      'writing': '🏆 Best for long articles: Claude. Best for marketing copy: Copy.ai. Best for blog posts: Writesonic.',
      'presentations': '🏆 Best AI slides: Gamma. Best design: Canva AI. Best templates: Beautiful.ai.',
    };

    return ResponseResult(
      bestPicks[topic] ?? '🏆 Let me show you the top picks for $topic:',
      showTools: !bestPicks.containsKey(topic),
      toolQuery: bestPicks.containsKey(topic) ? null : 'best $topic',
    );
  }

  static ResponseResult _followupBeginner(ConversationContext ctx) {
    if (!ctx.isFollowUp) {
      return const ResponseResult(
        'What are you looking to learn? Tell me the category and I\'ll suggest beginner-friendly tools!',
      );
    }

    final topic = ctx.topicDisplayName;
    final beginnerPicks = <String, String>{
      'video editing': '🎓 For beginners, I recommend CapCut — it\'s free, intuitive, and has AI features that do the hard work for you!',
      'image generation': '🎓 Start with Microsoft Designer — it\'s free, easy to use, and powered by DALL-E 3. Just type what you want!',
      'coding': '🎓 Start with Replit AI — it\'s a free cloud IDE where you can code with AI help. No setup needed!',
      'music creation': '🎓 Try Suno AI — just describe what kind of song you want and it creates everything including lyrics!',
      'AI assistants': '🎓 Start with Gemini — it\'s free, simple, and connected to Google Search for accurate answers!',
    };

    return ResponseResult(
      beginnerPicks[topic] ?? 'For beginners in $topic, let me find the easiest tools:',
      showTools: !beginnerPicks.containsKey(topic),
      toolQuery: beginnerPicks.containsKey(topic) ? null : '$topic beginner',
    );
  }

  static ResponseResult _followupMore(ConversationContext ctx) {
    if (ctx.lastToolCategory != null) {
      return ResponseResult(
        'Here are more ${ctx.topicDisplayName} tools to explore:',
        showTools: true,
        toolQuery: ctx.topicDisplayName,
      );
    }

    return ResponseResult(_pick([
      'What would you like to know more about? I can dive deeper into any topic! 🧐',
      'Sure! What specific area would you like me to elaborate on?',
      'Happy to share more! Just tell me the topic. 😊',
    ]));
  }

  // ═══════════════════════════════════════════════════════
  // CONVERSATIONAL RESPONSES
  // ═══════════════════════════════════════════════════════

  static ResponseResult _affirm(ConversationContext ctx) {
    if (ctx.lastIntent == 'tool_search') {
      return const ResponseResult(
        'Great! Would you like to know which one is free, best for beginners, or the overall top pick? 🎯',
      );
    }
    return ResponseResult(_pick([
      'Awesome! What else can I help you with? 😊',
      'Great! Feel free to ask me anything!',
      'Perfect! I\'m here if you need more help! 💪',
    ]));
  }

  static ResponseResult _deny() {
    return ResponseResult(_pick([
      'No worries! Let me know if you change your mind. I\'m here! 😊',
      'That\'s okay! Feel free to ask me something else anytime.',
      'Alright! I\'m ready whenever you need me. 🙌',
    ]));
  }

  static ResponseResult _fallback(ConversationContext ctx, String rawInput) {
    final q = rawInput.toLowerCase();

    if (q.contains('code') || q.contains('coding') || q.contains('programming') || q.contains('bug')) {
      return const ResponseResult(
        'I can help with coding basics, debugging direction, and tool picks. Share your language + error, and I will give a step-by-step fix.',
      );
    }

    if (q.contains('study') || q.contains('learn') || q.contains('exam') || q.contains('career')) {
      return const ResponseResult(
        'Great goal. I can help you make a practical learning plan, daily routine, and best free tools. Tell me your target and how many hours per day you have.',
      );
    }

    if (q.contains('business') || q.contains('startup') || q.contains('marketing') || q.contains('grow')) {
      return const ResponseResult(
        'Nice question. I can help with startup planning, marketing ideas, and AI tools to save time. Tell me your niche and current stage, and I will suggest a focused action plan.',
      );
    }

    if (q.contains('health') || q.contains('workout') || q.contains('diet') || q.contains('fitness')) {
      return const ResponseResult(
        'I can share general wellness tips and planning ideas, but for medical advice always consult a professional. If you want, I can build a simple daily routine for you.',
      );
    }

    if (ctx.isFollowUp) {
      return ResponseResult(
        'I\'m not sure I understood that. Were you asking about ${ctx.topicDisplayName}? Try being more specific! 😊',
      );
    }
    return ResponseResult(_pick([
      'Hmm, I\'m not sure about that yet. But I can help you with:\n\n• 🔍 Finding AI tools (video, image, code, music)\n• 💡 Productivity tips\n• 😄 Jokes and motivation\n• 📊 Tracking your tool usage\n\nTry asking something like "best free video editor"!',
      'I didn\'t quite get that, but here\'s what I\'m great at:\n\n• AI tool recommendations\n• Quick tips and advice\n• General chat and fun\n\nWhat would you like to explore? 🚀',
      'That\'s a bit outside my expertise right now! But I\'m constantly learning. Meanwhile, I can help with AI tools, tips, and more. What interests you? 🤔',
    ]));
  }

  // ── Helper ──
  static String _pick(List<String> options) {
    return options[_rng.nextInt(options.length)];
  }
}
