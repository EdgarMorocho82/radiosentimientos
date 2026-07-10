import 'dart:async';

import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'package:radioxr/constants/config.dart';
import 'package:radioxr/models/timestop_models.dart';
import 'package:volume_regulator/volume_regulator.dart';
import 'dart:typed_data';

class PlayerScreenModel with ChangeNotifier {
  bool isPlaying = false;
  bool isLoading = false;
  double volume = 0.5;

  Uint8List? artworkData;
  Metadata? metadata;

  late final SmartstopService _smartstopService;

  bool _stationReady = false;
  DateTime? _lastPausedAt;
  bool _wantsPlay = false;

  static const Duration _reconnectThreshold = Duration(seconds: 3);

  StreamSubscription<int>? _volSub;
  StreamSubscription<PlaybackState>? _pbSub;
  StreamSubscription<Metadata>? _mdSub;
  StreamSubscription<RemoteCommand>? _cmdSub;

  Future<void> stop() async {
    _wantsPlay = false;
    _smartstopService.stop();
    try {
      await RadioPlayer.pause();
    } catch (_) {}

    try {
      await RadioPlayer.reset();
      _stationReady = false;
    } catch (_) {}

    _lastPausedAt = null;
    isPlaying = false;
    isLoading = false;
    notifyListeners();
  }

  PlayerScreenModel() {
    _configureStation();

    if (Config.autoplay) {
      _wantsPlay = true;
      isLoading = true;
      RadioPlayer.play();
      notifyListeners();
    }

    _smartstopService = SmartstopService(
      callback: () => RadioPlayer.pause(),
      duration: const Duration(seconds: 60),
    );

    VolumeRegulator.getVolume().then((v) {
      volume = (v.toDouble() / 80.0).clamp(0.0, 1.0);
      notifyListeners();
    });

    _volSub = VolumeRegulator.volumeStream.listen((v) {
      final newVol = (v.toDouble() / 80.0).clamp(0.0, 1.0);
      if (newVol != volume) {
        volume = newVol;
        notifyListeners();
      }
    });

    _pbSub = RadioPlayer.playbackStateStream.listen((PlaybackState state) {
      final currentlyPlaying = state.isPlaying;

      if (isLoading && _wantsPlay && !currentlyPlaying) {
        return;
      }

      if (currentlyPlaying) {
        if (isLoading) isLoading = false;
        if (_wantsPlay) _wantsPlay = false;
      } else {
        if (isLoading && !_wantsPlay) isLoading = false;
      }

      if (isPlaying != currentlyPlaying) {
        isPlaying = currentlyPlaying;
        isPlaying ? _onPlay() : _onPause();
      }
      notifyListeners();
    });

    _mdSub = RadioPlayer.metadataStream.listen((md) {
      metadata = md;
      artworkData = md.artworkData;
      notifyListeners();
    });

    _cmdSub = RadioPlayer.remoteCommandStream.listen((command) {
      switch (command) {
        case RemoteCommand.nextTrack:
        case RemoteCommand.previousTrack:
        case RemoteCommand.unknown:
          break;
      }
    });
  }

  void _configureStation() {
    RadioPlayer.setStation(
      title: Config.appNameScreen,
      url: Config.linkStream,
      parseStreamMetadata: Config.metaData,
      lookupOnlineArtwork: Config.coverArtist,
    );
    _stationReady = true;
  }

  Future<void> _ensureStationReady() async {
    if (!_stationReady) {
      _configureStation();
    }
  }

  Future<void> play() async {
    if (isPlaying) return;

    _wantsPlay = true;
    isLoading = true;
    notifyListeners();

    final pausedFor = _lastPausedAt == null
        ? Duration.zero
        : DateTime.now().difference(_lastPausedAt!);

    if (pausedFor > _reconnectThreshold) {
      await RadioPlayer.reset();
      _stationReady = false;
    }

    await _ensureStationReady();
    await RadioPlayer.play();
  }

  Future<void> pause() async {
    _wantsPlay = false;
    await RadioPlayer.pause();
    _lastPausedAt = DateTime.now();
  }

  Future<void> reset() async {
    _wantsPlay = false;
    await RadioPlayer.reset();
    _stationReady = false;
    _lastPausedAt = null;
    isPlaying = false;
    isLoading = false;
    notifyListeners();
  }

  void _onPlay() {
    _smartstopService.stop();
  }

  void _onPause() {
    _smartstopService.start();
  }

  void setVolume(double value) {
    final v = value.clamp(0.0, 1.0);
    if (v == volume) return;
    volume = v;
    VolumeRegulator.setVolume((volume * 100).toInt());
    notifyListeners();
  }

  @override
  void dispose() {
    _smartstopService.stop();
    _volSub?.cancel();
    _pbSub?.cancel();
    _mdSub?.cancel();
    _cmdSub?.cancel();
    super.dispose();
  }

  String get artist => metadata?.artist ?? Config.appNameScreen;
  String get track => metadata?.title ?? Config.appDescription;
}
