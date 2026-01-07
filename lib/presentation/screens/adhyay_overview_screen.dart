import 'package:flutter/material.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/data/models/playlist.dart';
import 'package:geeta_santha/data/models/shlok.dart';
import 'package:geeta_santha/presentation/widgets/nav_pill.dart';
import 'package:geeta_santha/presentation/widgets/shlok_selection.dart';
import 'package:provider/provider.dart';

import '../providers/playlist_provider.dart';
import '../widgets/verse_page.dart';
import '../widgets/mini_player.dart';

class AdhyayOverviewScreen extends StatefulWidget {
  static const routeName = "/AdhyayOverviewScreen";

  final String adhyayName;
  final int chapterNumber;
  final Playlist playlist;
  final int initialPage;

  const AdhyayOverviewScreen({
    super.key,
    required this.adhyayName,
    required this.chapterNumber,
    required this.playlist,
    this.initialPage = 0,
  });

  @override
  State<AdhyayOverviewScreen> createState() => _AdhyayOverviewScreenState();
}

class _AdhyayOverviewScreenState extends State<AdhyayOverviewScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistProvider>().setPlaylist(widget.playlist.chapterNo);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showShlokJumpDialog(BuildContext context, int numberOfShloks) {
    showDialog(
      context: context,
      builder: (_) => ShlokSelection(
        pageController: _pageController,
        numberOfShloks: numberOfShloks, // pass shlok numbers or titles3
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 BODY
      body: Column(
        children: [
          // 🔸 Gradient Header (instead of AppBar)
          Container(
            height: scaleHeight(context, 180),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5F2EEA), // deep purple
                  Color(0xFF3A86FF), // blue
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.adhyayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: scaleWidth(context, 30), color: Colors.white),
                ),
               SizedBox(height: scaleHeight(context, 8)),
                Text(
                  'अध्याय ${widget.chapterNumber} - श्लोक ${_currentPage + 1}',
                  style:  TextStyle(color: Colors.white70, fontSize: scaleWidth(context, 16)),
                ),
              ],
            ),
          ),

          // 🔸 SHLOK PAGE VIEW
          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: widget.playlist.shloks.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final Shlok shlok = widget.playlist.shloks[index];
                return VersePage(
                  shlok: shlok,
                  isLastPage: index == widget.playlist.shloks.length - 1,
                  pageController: _pageController,
                  // onPlayPause: onPlayPause,
                  // onStop: onStop,
                  // onRestart: onRestart,
                  // onSeek: onSeek,
                );
              },
            ),
          ),

          // Inside Column of AdhyayOverviewScreen, below PageView
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Prev button
                if (_currentPage != 0)
                  NavPill(
                    label: "Prev",
                    icon: Icons.chevron_left,
                    onTap: () {
                      _pageController.animateToPage(
                        _currentPage - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),

                // Jump button in middle
                NavPill(
                  label: "Jump",
                  icon: Icons.keyboard_double_arrow_down,
                  onTap: () {
                    _showShlokJumpDialog(context, widget.playlist.count);
                  },
                ),

                // Next button
                if (_currentPage != widget.playlist.shloks.length - 1)
                  NavPill(
                    label: "Next",
                    icon: Icons.chevron_right,
                    isNext: true,
                    onTap: () {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
              ],
            ),
          ),

          Consumer<PlaylistProvider>(
            builder: (context, player, _) {
              final bool shouldShowMiniPlayer =
                  player.hasActiveTrack &&
                  !player.isCurrentShlok(
                    widget.playlist.chapterNo,
                    _currentPage + 1,
                  );
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: shouldShowMiniPlayer
                    ?  MiniPlayer(onVersePage: true)
                    : const SizedBox.shrink(),
              );
            },
          ),
          //
        ],
      ),
    );
  }
}
