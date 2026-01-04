import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/data/models/shlok.dart';
import 'package:geeta_santha/presentation/providers/playlist_provider.dart';
import 'package:geeta_santha/presentation/widgets/music_player.dart';
import 'package:provider/provider.dart';

class VersePage extends StatefulWidget {
  final Shlok shlok;
  final PageController pageController;
  final bool isLastPage;
  // final ValueChanged<int> onPlayPause;
  // final VoidCallback onStop;
  // final VoidCallback onRestart;
  // final ValueChanged<double> onSeek;

  const VersePage({
    Key? key,
    required this.shlok,
    required this.pageController,

    // required this.onPlayPause,
    // required this.onStop,
    // required this.onRestart,
    // required this.onSeek,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  late PlaylistProvider _player;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _player = context.read<PlaylistProvider>();
  }

  void onPlayPause() {
    if (_player.isCurrentShlok(widget.shlok.chapterNo, widget.shlok.shlokNo)) {
      print(
        "Logs VersePage-onPlayPause Playing/Pausing chap-${widget.shlok.chapterNo} shlok-${widget.shlok}.shlokNo",
      );
      _player.playPause();
    } else {
      // playing if there is none or another shlok
      print(
        "Logs VersePage-onPlayPause Playing chap-${widget.shlok.chapterNo} shlok-${widget.shlok.shlokNo}",
      );

      _player.setIsRepeactCurrent(false);
      _player.playShlokFromPlaylist(widget.shlok.shlokNo);
    }
  }

  void onAutoPlay() {
    print(
      "Logs VersePage-onStop Stoping chap-${_player.activePlaylistIndex! + 1} shlok-${_player.currentShlokIndex + 1}",
    );
    _player.setAutoPlay(!_player.isAutoPlay!);
  }


  void onRepeatCurrent() {
    print(
      "Logs VersePage-onRestart Restarting chap-${_player.activePlaylistIndex! + 1} shlok-${_player.currentShlokIndex + 1}",
    );
    _player.setIsRepeactCurrent(!_player.isRepeatCurrent!);
  }

  void onSeek(double seconds) {
    print(
      "Logs VersePage-onSeek Seeking chap-${_player.activePlaylistIndex! + 1} shlok-${_player.currentShlokIndex + 1}",
    );
    _player.seek(seconds);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final player = context.watch<PlaylistProvider>();

    final bool isCurrent = player.isCurrentShlok(
      widget.shlok.chapterNo,
      widget.shlok.shlokNo,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: scaleHeight(context, 30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔢 SHLOK CHIP
              Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: scaleWidth(context, 18),
                      vertical: scaleHeight(context, 8),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: scaleHeight(context, 20),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [primaryPurple, primaryBlue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'श्लोक ${widget.shlok.shlokNo}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: scaleWidth(context, 14),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),

              /// 📜 SHLOK CARD
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: GradientText(
                    widget.shlok.text,
                    fontSize: scaleWidth(context, 24),
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.28,

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(context, 30),
                  ),
                  child: MusicPlayer(
                    currentSeconds: isCurrent ? player.currentSeconds : 0,
                    totalSeconds: isCurrent ? player.totalSeconds : 0,
                    isPlaying: player.isPlaying,
                    isCurrent: isCurrent,
                    isAutoPlay: player.isAutoPlay!,
                    isRepeatCurrent: player.isRepeatCurrent!,
                    onPlayPause: onPlayPause,
                    onAutoPlay: onAutoPlay,
                    onRepeactCurrent: onRepeatCurrent,
                    onSeek: onSeek,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const GradientText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFF5F2EEA), // purple
            Color(0xFF3A86FF), // blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white, // REQUIRED
        ),
      ),
    );
  }
}
