import 'package:flutter/material.dart';
import 'package:geeta_santha/core/services/audio_player_service.dart';
import 'package:geeta_santha/core/services/audio_storage_service.dart';


class PlaylistProvider extends ChangeNotifier {
  

  final List<int> shlokCounts = [
  47, 72, 43, 42, 29, 47, 30, 28, 34,
  42, 55, 20, 35, 27, 20, 24, 28, 78
  ];

  final int adhyayCount = 18;


  PlaylistProvider(this._storage, this._player) {

  _player.positionStream.listen((seconds) {
    _currentSeconds = seconds;
    // Update totalSeconds if it wasn't available immediately after play
    if (_player.durationSeconds > 0 && _totalSeconds != _player.durationSeconds) {
      _totalSeconds = _player.durationSeconds;
    }
    notifyListeners();
  });


  // 🔥 ADD THIS
  _player.onComplete.listen((_) {
    _handleTrackCompletion();
  });
}
  int? _playlistIndex;
  int? _activePlaylistIndex;

  final AudioPlayerService _player;
  final AudioStorageService _storage;


  bool _isRepeatCurrent = false;
  bool _isAutoPlay = false;
  bool _isPlaying = false;
  bool hasActiveTrack = false;

  int _currentShlokIndex = 0;
  double _currentSeconds = 0;
  double _totalSeconds = 0;

  // ───────────────── GETTERS ─────────────────

  int? get playlist => _playlistIndex;
  int? get activePlaylistIndex => _activePlaylistIndex;
  bool? get isRepeatCurrent => _isRepeatCurrent;
  bool? get isAutoPlay => _isAutoPlay;


  // Shlok? get currentShlok =>
  //     _activePlaylistIndex == null ? null : _activePlaylist!.shloks[_currentShlokIndex];

  int get currentShlokIndex => _currentShlokIndex;

  bool get isPlaying => _isPlaying;

  double get currentSeconds => _currentSeconds;
  double get totalSeconds => _totalSeconds;

  bool isCurrentShlok(int chapterNo, int shlokNo) {
    if(_activePlaylistIndex == null) return false;
    print(
      "Logs Provider-isCurrentShlok chap-${_activePlaylistIndex!+1} sholk-${_currentShlokIndex+1} ,  my chap-$chapterNo sholk-$shlokNo",
    );
    return hasActiveTrack &&
        (_activePlaylistIndex!+1 == chapterNo &&
            _currentShlokIndex+1 == shlokNo);
  }

  // ───────────────── PLAYLIST CONTROL ─────────────────

  void setPlaylist(int chapterNumber) {
    _playlistIndex = chapterNumber-1;

    // print(
    //   "Logs Provider-setPlaylist playlist-${_playlist?.chapterNo} active-${_activePlaylist?.chapterNo} ",
    // );
  }

  void setIsRepeactCurrent(bool  isRepeatCurrent){
      _isRepeatCurrent = isRepeatCurrent;
      if(isRepeatCurrent) _isAutoPlay = false;
  }

  void setAutoPlay(bool isAutoPlay){
    _isAutoPlay = isAutoPlay;
    if(isAutoPlay) _isRepeatCurrent = false;
  }

  Future<void> playShlokFromPlaylist(int shlokNo) async {
   if (_playlistIndex == null) return;

  _activePlaylistIndex = _playlistIndex;
  _currentShlokIndex = shlokNo - 1;
    await _playCurrent();
  }

  Future<void> _playCurrent() async {


    _isPlaying = true;

    _currentSeconds = 0;
    hasActiveTrack = true; 
    // final shlok = currentShlok!;
    final localPath = await _storage.getShlokPath(
      _activePlaylistIndex!+1,
     _currentShlokIndex+1,
    );

    // print(
    //   "Logs Provider-playcurrent chap-${currentShlok?.chapterNo} sholk-${currentShlok?.shlokNo} Local path - $localPath",
    // );

    await _player.play(localPath);

     
    _totalSeconds = _player.durationSeconds;
    // _listenProgress();
    notifyListeners();
  }

  // ───────────────── PROGRESS LISTENER ─────────────────

  // void _listenProgress() {
  //   _player.positionStream.listen((seconds) {
  //     _currentSeconds = seconds;
  //     notifyListeners();
  //   });
  // }

  // ───────────────── UI CALLBACKS ─────────────────

  /// ▶️ ⏸ Play / Pause
  void playPause() {
   if (!hasActiveTrack) return;

  if (_isPlaying) {
    _player.pause();
    _isPlaying = false;
  } else {
    _player.resume();
    _isPlaying = true;
  }

  notifyListeners();
  }

  /// ⏹ Stop
  void stop() {
    _player.stop();
    _isPlaying = false;
    _isAutoPlay = false;
    _isRepeatCurrent = false;
    _currentSeconds = 0;
    hasActiveTrack = false;
    notifyListeners();
  }

  /// 🔁 Restart current shlok
  Future<void> restart() async {
    _player.stop();
    await _playCurrent();
  }

  /// ⏩ Seek
  void seek(double seconds) {
    _player.seek(seconds);
    _currentSeconds = seconds;
    notifyListeners();
  }


  void _handleTrackCompletion() {
  if (_activePlaylistIndex == null) return;
  
  if(_isRepeatCurrent){
    _playCurrent();
    return;
  }

  if(!_isAutoPlay) return;

  if (_currentShlokIndex < shlokCounts[_activePlaylistIndex!]-1) {
    // ▶️ play next shlok
    _currentShlokIndex++;
    _playCurrent();
  } else {
    // ⏹ playlist finished
    _isPlaying = false;
    hasActiveTrack = false;
    _currentSeconds = 0;

    
    _activePlaylistIndex = (_activePlaylistIndex!+1)%adhyayCount;
    _currentShlokIndex = 0;
    _playCurrent();
    notifyListeners();
  }
}

}
