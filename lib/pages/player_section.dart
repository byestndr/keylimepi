import 'package:flutter/material.dart';
import 'package:spotimmich/pages/info_page.dart';
import 'package:spotimmich/pages/lyrics_page.dart';

class PlayerSection extends StatefulWidget {
  const PlayerSection({super.key});

  @override
  State<PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: .vertical,
      physics: const BouncingScrollPhysics(),
      controller: _pageController,
      children: [const LyricsPage(), const InfoPage()],
    );
  }
}
