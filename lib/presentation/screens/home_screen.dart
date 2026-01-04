import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/adhay_details.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/data/repositories/get_all_adhyay_shloks.dart';
import 'package:geeta_santha/data/models/playlist.dart';
import 'package:geeta_santha/presentation/providers/playlist_provider.dart';
import 'package:geeta_santha/presentation/screens/adhyay_overview_screen.dart';
import 'package:geeta_santha/presentation/widgets/mini_player.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

   HomeScreen({super.key});
  
  final GeetaRepository geetaRepository =  GeetaRepository();

  @override
  Widget build(BuildContext context) {

   List<Playlist> playlists = geetaRepository.getAllAdhyayShloks() ;
    
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: scaleHeight(context, 180),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryPurple,primaryBlue// blue
                ],
              ),
            ),
            child:  Text(
              'श्रीमद्भगवद्गीता',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: scaleWidth(context, 30),
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(height: scaleHeight(context, 5)),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: scaleWidth(context, 16), vertical: scaleHeight(context, 16)),
              itemCount: playlists.length,
              separatorBuilder: (_, __) =>  SizedBox(height: scaleHeight(context, 12)),
              itemBuilder: (context, index) {
                final chapterNumber = index + 1;
                final shlokCount = playlists[index].count; 

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdhyayOverviewScreen(
                          adhyayName: chapterNames[index],
                          chapterNumber: chapterNumber,
                          playlist: playlists[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: scaleWidth(context, 16), vertical: scaleHeight(context, 16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF6F7FB),
                    ),
                    child: Row(
                      children: [
                        // Chapter number circle
                        Container(
                          height:scaleHeight(context, 44),
                          width: scaleWidth(context, 44),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4D96FF)],
                            ),
                          ),
                          child: Text(
                            '$chapterNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(width: scaleWidth(context, 16)),

                        // Chapter name + shlok count
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapterNames[index],
                                style:  TextStyle(
                                  fontSize: scaleWidth(context, 16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: scaleHeight(context, 4)),
                              Text(
                                '$shlokCount श्लोक',
                                style:  TextStyle(
                                  fontSize: scaleWidth(context, 13),
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔸 MINI PLAYER (YOUTUBE MUSIC Style)
          Consumer<PlaylistProvider>(
            builder: (context, player, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: player.hasActiveTrack
                    ? MiniPlayer(onVersePage: false,)
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
