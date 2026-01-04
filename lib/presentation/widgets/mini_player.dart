import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/adhay_details.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/core/utils/format_time.dart';
import 'package:geeta_santha/data/models/shlok.dart';
import 'package:geeta_santha/data/repositories/get_all_adhyay_shloks.dart';
import 'package:geeta_santha/presentation/screens/adhyay_overview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';


class MiniPlayer extends StatelessWidget {
  final bool onVersePage;
  final GeetaRepository geetaRepository =  GeetaRepository();


   MiniPlayer({super.key, required this.onVersePage});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlaylistProvider>();

    final currentChapterIndex = player.activePlaylistIndex!;
    final currentShlokIndex = player.currentShlokIndex;

    final currentSeconds = player.currentSeconds;
    final totalSeconds = player.totalSeconds;


    void navigateToVersePage() {
      final page = AdhyayOverviewScreen(
                          adhyayName: chapterNames[currentChapterIndex],
                          chapterNumber: currentChapterIndex+1,
                          playlist: geetaRepository.getAdhyayShloks(currentChapterIndex+1),
                          initialPage: currentShlokIndex,
        );

      if (onVersePage) {
        // Replace current page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      } else {
        // Navigate normally
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      }
    }

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🎵 Thumbnail / Icon
          GestureDetector(
            onTap: navigateToVersePage,
            child: Container(
              height: scaleHeight(context, 42),
              width: scaleWidth(context, 42),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [primaryPurple,primaryBlue
                  ],
                ),
              ),
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
          ),

          SizedBox(width: scaleWidth(context, 12)),

          // 📝 Title
          Expanded(
            child: GestureDetector(
              onTap: navigateToVersePage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'अध्याय ${currentChapterIndex+1}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: scaleWidth(context, 14),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                   SizedBox(height: scaleHeight(context, 2)),
                  Text(
                    'श्लोक ${currentShlokIndex +1}',
                    style:  TextStyle(
                      fontSize: scaleWidth(context, 12),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ⏱ Time
          GestureDetector(
            onTap: navigateToVersePage,
            child: Text(
              "${formatTime(currentSeconds)} / ${formatTime(totalSeconds)}",
              style:  TextStyle(
                fontWeight: FontWeight.w600,
                fontSize:scaleWidth(context, 14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

           SizedBox(width: scaleWidth(context, 12)),

          // Restart button
          IconButton(
            icon: Icon(Icons.auto_mode, size: scaleWidth(context, 35), color: primaryGreen1),
            onPressed: () => player.restart(),
          ),

          // Play / Pause
          IconButton(
            icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow,
                size: scaleWidth(context, 40), color: primaryBlue),
            onPressed: () => player.playPause(),
          ),

          // Stop
          IconButton(
            icon: Icon(Icons.stop_circle, size: scaleWidth(context, 40), color: primaryRed1),
            onPressed: () => player.stop(),
          ),
        ],
      ),
    );
  }
}
