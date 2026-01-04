
import 'package:flutter/material.dart';
import 'package:geeta_santha/core/services/audio_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'package:geeta_santha/presentation/screens/donwload_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAudioStatus();
  }


  Future<void> _checkAudioStatus() async {
    final storage = context.read<AudioStorageService>();

    // Small delay for branding feel
    await Future.delayed(const Duration(milliseconds: 800));

    final allPresent = await storage.areAllFilesPresent();
   
    print("Does all Audio file present - $allPresent");
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => allPresent ?  HomeScreen() : const DownloadScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: scaleWidth(context, 90),
              color: Color(0xFF5F2EEA),
            ),
            SizedBox(height: scaleHeight(context, 20)),
            Text(
              'श्रीमद्भगवद्गीता',
              style: TextStyle(
                fontSize: scaleWidth(context, 28),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: scaleHeight(context, 10)),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
