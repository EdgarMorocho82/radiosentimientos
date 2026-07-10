import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:radioxr/constants/config.dart';

class MetadataService {
  final void Function(List<String>) callback;
  final String metadataUrl;
  List<String>? _previousMetadata;
  Timer? _timer;

  MetadataService({
    required this.callback,
    required this.metadataUrl,
  });

  void start() {
    stop();
    _timer = Timer.periodic(const Duration(seconds: 2), _parser);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _parser(Timer t) async {
    List<String> metadata = ['', '', ''];
    String title = '';
    try {
      final response = await get(Uri.parse(metadataUrl));
      final content = utf8.decode(response.bodyBytes);

      try {
        var map = json.decode(content) as Map<String, dynamic>;
        map = map['now_playing']?['song'] ?? map;

        title = map['titleTag'] ?? '';
        metadata[0] = map['artist'] ?? '';
        metadata[1] = map['title'] ?? '';
        metadata[2] = map['thumb'] ?? '';
      } catch (_) {
        title = _betweenTag(content, 'titleTag');
        metadata[0] = _betweenTag(content, 'artist');
        metadata[1] = _betweenTag(content, 'title');
        metadata[2] = _betweenTag(content, 'thumb');
      }

      if (title.isNotEmpty) {
        final titleList = title.split(' - ');
        metadata[0] = titleList[0];
        metadata[1] = (titleList.length > 1) ? titleList[1] : '';
      }

      if (metadata[0].isEmpty && metadata[1].isEmpty) {
        return;
      }

      if (metadata[0].isEmpty) {
        metadata[0] = metadata[1];
        metadata[1] = '';
      }

      if (metadata[1].isEmpty) {
        metadata[1] = Config.appNameScreen;
      }

      if (!listEquals(metadata, _previousMetadata)) {
        _previousMetadata = List.from(metadata);
        callback(metadata);
      }
    } catch (e) {}
  }

  String _betweenTag(String source, String tag) {
    final start = source.indexOf('<$tag>');
    final end = source.indexOf('</$tag>');
    if (start == -1 || end == -1) return '';
    return source.substring(start + tag.length + 2, end);
  }
}
