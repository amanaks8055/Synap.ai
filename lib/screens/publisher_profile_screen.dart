import 'package:flutter/material.dart';

class PublisherProfileScreen extends StatefulWidget {
  const PublisherProfileScreen({super.key});

  @override
  State<PublisherProfileScreen> createState() => _PublisherProfileScreenState();
}

class _PublisherProfileScreenState extends State<PublisherProfileScreen> {
  int _selectedTab = 0;
  bool _isFollowing = false;

  final List<Map<String, String>> _newsList = [
    {
      'thumb': 'blue',
      'cat': 'Travel',
      'readtime': '5 min read',
      'time': '3 hours ago',
      'title': 'The UNESCO World Heritage Site with sky-high house prices',
    },
    {
      'thumb': 'purple',
      'cat': 'Tech',
      'readtime': '8 min read',
      'time': '7 hours ago',
      'title': 'Facebook to hire 10,000 in EU to work on metaverse',
    },
    {
      'thumb': 'green',
      'cat': 'Sport',
      'readtime': '12 min read',
      'time': '9 hours ago',
      'title': 'Champions League news conferences',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1120),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfile(),
                    _buildBio(),
                    _buildLink(),
                    _buildStats(),
                    _buildTabs(),
                    _buildNewsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF151D30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_left,
                  color: Color(0xFFAABBCC), size: 20),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFF151D30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_outlined,
                color: Color(0xFFAABBCC), size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFCC1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'BBC\nNEWS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BBC News',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '@bbc',
                  style: TextStyle(
                    color: Color(0xFF556677),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _isFollowing = !_isFollowing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isFollowing
                          ? const Color(0xFF151D30)
                          : const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(20),
                      border: _isFollowing
                          ? Border.all(color: const Color(0xFFE53935), width: 1)
                          : null,
                    ),
                    child: Text(
                      _isFollowing ? 'Following' : '+ Follow',
                      style: TextStyle(
                        color: _isFollowing
                            ? const Color(0xFFE53935)
                            : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        style: TextStyle(
          color: Color(0xFF889AAA),
          fontSize: 11,
          height: 1.55,
        ),
      ),
    );
  }

  Widget _buildLink() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Row(
        children: const [
          Icon(Icons.link, color: Color(0xFFE53935), size: 14),
          SizedBox(width: 5),
          Text(
            'bbc.com',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      {'val': '230', 'label': 'News'},
      {'val': '25K', 'label': 'Follower'},
      {'val': '120', 'label': 'Following'},
      {'val': '50K', 'label': 'Upvoted'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(stats.length, (i) {
          return Expanded(
            child: Container(
              decoration: i < stats.length - 1
                  ? const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            color: Color(0xFF1E2A3A), width: 1),
                      ),
                    )
                  : null,
              child: Column(
                children: [
                  Text(
                    stats[i]['val']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stats[i]['label']!,
                    style: const TextStyle(
                      color: Color(0xFF556677),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Row(
        children: ['News', 'Upvote'].asMap().entries.map((e) {
          final isActive = _selectedTab == e.key;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFE53935)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e.value,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : const Color(0xFF556677),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: _newsList.map((item) => _buildNewsCard(item)).toList(),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, String> item) {
    final thumbColors = {
      'blue': [const Color(0xFF1A3550), const Color(0xFF2D5A7E)],
      'purple': [const Color(0xFF1E1A35), const Color(0xFF2A2050)],
      'green': [const Color(0xFF1A2A1A), const Color(0xFF1E3A20)],
    };
    final gradColors = thumbColors[item['thumb']] ??
        [const Color(0xFF1A2A3A), const Color(0xFF2A3A4A)];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF131B2E), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradColors,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${item['cat']?.toUpperCase()} · ${item['readtime']}',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 8,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item['time'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFFDDEEFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['readtime'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF556677),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
