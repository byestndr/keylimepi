import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/lyrics/lyric_classes.dart';
import 'package:spotimmich/providers/settings_provider.dart';

class LyricLineWidget extends ConsumerStatefulWidget {
  final bool isCurrentLyric;
  final LyricLine lyric;
  const LyricLineWidget({
    super.key,
    required this.isCurrentLyric,
    required this.lyric,
  });

  @override
  ConsumerState<LyricLineWidget> createState() => _LyricLineWidgetState();
}

class _LyricLineWidgetState extends ConsumerState<LyricLineWidget> {
  @override
  Widget build(BuildContext context) {
    final double lyricFontSize = ref.read(userSettingsProvider).lyricFontSize;

    return InkWell(
      onTap: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();

        spotifyAPI.seekSong(widget.lyric.timestamp.inMilliseconds);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            fontSize: widget.isCurrentLyric ? lyricFontSize + 4 : lyricFontSize,
            fontFamilyFallback: <String>['NotoSansJP'],
            fontFamily: 'RobotoFlexVariable',
            fontVariations: [
              widget.isCurrentLyric
                  ? const FontVariation.width(130)
                  : const FontVariation.width(120),
              widget.isCurrentLyric
                  ? const FontVariation.weight(850)
                  : const FontVariation.weight(600),
            ],
          ),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Text(widget.lyric.line),
        ),
      ),
    );
  }
}