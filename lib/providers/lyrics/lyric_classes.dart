import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:romanize/romanize.dart';

class LyricLine {
  Duration timestamp;
  String line;
  LyricLine({required this.line, required this.timestamp});

  static List<LyricLine> fromSyncedLyrics(String lyrics) {
    final List<String> splitLyrics = const LineSplitter().convert(lyrics);
    List<LyricLine> lyricsList = <LyricLine>[];
    for (final String line in splitLyrics) {
      final RegExp regEx = RegExp(r'\[(\d+):(\d{2}(?:\.\d+)?)\]');
      final String? unprocesssedTimestamp = regEx.stringMatch(line);

      if (unprocesssedTimestamp == null) {
        continue;
      }

      final String bracketlessTimestamp = unprocesssedTimestamp.replaceAll(
        RegExp(r'\[|\]'),
        '',
      );
      final List<String> splitTimestamp = bracketlessTimestamp.split(':');
      final int timestampMinute = int.parse(splitTimestamp[0]);

      final List<String> splitSeconds = splitTimestamp[1].split('.');
      final int timestampSeconds = int.parse(splitSeconds[0]);
      final int timestampMiliseconds = int.parse(splitSeconds[1]);

      final Duration timestamp = Duration(
        minutes: timestampMinute,
        seconds: timestampSeconds,
        milliseconds: timestampMiliseconds,
      );

      final String lyricLine = line
          .replaceAll(unprocesssedTimestamp, '')
          .trim();

      lyricsList.add(LyricLine(line: lyricLine, timestamp: timestamp));
    }
    return lyricsList;
  }

  Future<LyricLine> romanize() async {
    if (line.isEmpty) {
      return LyricLine(line: line, timestamp: timestamp);
    }

    final Romanizer analyzedText = TextRomanizer.detectLanguage(line);
    if (analyzedText.language != 'japanese') {
      final String romanizedText = analyzedText.romanize(line);
      return LyricLine(line: romanizedText, timestamp: timestamp);
    }

    final Map<String, dynamic> romanizedLyrics = await _getRomanizedLyrics();

    return LyricLine(line: romanizedLyrics['converted'], timestamp: timestamp);
  }

  Future<Map<String, dynamic>> _getRomanizedLyrics() async {
    final Uri romajiURI = Uri(
      scheme: 'https',
      host: 'yomi.onrender.com',
      path: '/analyze',
    );
    final http.Response response = await http.post(
      romajiURI,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'text': line,
        'to': 'romaji',
        'romaji_system': 'hepburn',
        'mode': 'spaced',
      },
    );

    // Body is a string so some reason, so we decode twice.
    final dynamic strippedString = jsonDecode(response.body);
    final Map<String, dynamic> convertedBody = jsonDecode(strippedString);

    return convertedBody;
  }
}