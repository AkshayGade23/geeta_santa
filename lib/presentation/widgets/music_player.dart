import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/core/utils/format_time.dart';


class MusicPlayer extends StatelessWidget {
  final double currentSeconds;
  final double totalSeconds;
  final bool isPlaying;
  final bool isCurrent;
  final bool isRepeatCurrent;
  final bool isAutoPlay;
  final VoidCallback onPlayPause;
  final VoidCallback onAutoPlay;
  final VoidCallback onRepeactCurrent;
  final ValueChanged<double> onSeek;

  const MusicPlayer({
    super.key,
    required this.currentSeconds,
    this.totalSeconds = 40,
    required this.isPlaying,
    required this.isRepeatCurrent,
    required this.isAutoPlay,
    required this.isCurrent,
    required this.onPlayPause,
    required this.onAutoPlay,
    required this.onRepeactCurrent,
    required this.onSeek,
  });

  
  Widget getButton({
    double? cotainerSize,
    List<Color>? gradientColors,
    double? boxShadowBlurRadius,
    IconData? icon,
    double? iconSize,
    VoidCallback? onTap,
    BuildContext? context,
    bool? isPlayPause = false,
    bool? showBackground = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: scaleHeight(context!, cotainerSize!),
        width: scaleWidth(context, cotainerSize),
        decoration: isPlayPause! || showBackground! ?
        BoxDecoration(
          gradient: LinearGradient(colors: gradientColors!),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withOpacity(0.7),
              blurRadius: boxShadowBlurRadius!,
              spreadRadius: 2,
            ) ,
          ],
        ) : BoxDecoration(),
        child: Icon(
          icon,
          color:  isPlayPause || showBackground! ? Colors.white : gradientColors![0],
          size: scaleWidth(context, iconSize!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Time display
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: scaleWidth(context, 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(currentSeconds)),
              Text(formatTime(totalSeconds)),
            ],
          ),
        ),

        // SquigglySlider(
        //   value: currentSeconds,
        //   min: 0,
        //   max: totalSeconds,
        //   squiggleAmplitude: 3,
        //   squiggleWavelength: 5,
        //   squiggleSpeed: 0.5,
        //   onChanged: onSeek
        // ),
        Slider(
          value: (totalSeconds > 0)
              ? currentSeconds.clamp(0.0, totalSeconds)
              : 0.0,
          min: 0,
          max: (totalSeconds > 0) ? totalSeconds : 1.0,
          activeColor: primaryBlue,
          onChanged: totalSeconds > 0 ? onSeek : null,
        ),

        SizedBox(height: scaleHeight(context, 16)),

        // Play/Pause & Stop buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //restart
            Column(
              children: [
                getButton(
                  cotainerSize: 40,
                  gradientColors: isCurrent
                      ? [primaryGreen1, primaryGreen2] // green gradient
                      : [primaryGrey1, primaryGrey2],
                  boxShadowBlurRadius: 12,
                  icon: Icons.repeat_rounded,
                  iconSize: 30,
                  onTap: isCurrent ? onRepeactCurrent : () {},
                  context: context,
                  showBackground: isCurrent && isRepeatCurrent,
                ),
                SizedBox(height: scaleHeight(context, 8)),
                Text("Repeat")
              ],
            ),

            // play/pause
            getButton(
              cotainerSize: 70,
              gradientColors: [primaryPurple, primaryBlue],
              boxShadowBlurRadius: 20,
              icon: isPlaying && isCurrent
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              iconSize: isPlaying && isCurrent ? 50 : 60,
              onTap: onPlayPause,
              context: context,
              isPlayPause: true
            ),

            // stop
            Column(
              children: [
                getButton(
                  cotainerSize: 40,
                  gradientColors: isPlaying
                      ? [primaryGreen1, primaryGreen2]
                      : [primaryGrey1, primaryGrey2],
                  boxShadowBlurRadius: 12,
                  icon: Icons.auto_mode,
                  iconSize: 30,
                  onTap: onAutoPlay ,
                  context: context,
                  showBackground:  isAutoPlay,
                ),
                SizedBox(height: scaleHeight(context, 8)),
                Text("Auto")
              ],
               
            ),
          ],
        ),
      ],
    );
  }
}
