import 'package:flutter/material.dart';
import 'package:geeta_santha/core/services/audio_download_service.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';
import 'home_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>   {
  int completed = 0;
  int total = 18;

  @override
  void initState() {
    super.initState();
   
    _startDownload();
  }


  Future<void> _startDownload() async {

  
    final service = AudioBulkDownloadService();

    await for (final progress in service.downloadAllWithProgress()) {
      setState(() {
        completed = progress.completed;
        total = progress.total;
      });
    }

    // ✅ Navigate once done
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = completed / total;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scaleWidth(context, 28)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔱 App Icon / Logo
               Icon(Icons.library_music,
                  size: scaleWidth(context, 80), color: Color(0xFF3A86FF)),

               SizedBox(height: scaleHeight(context, 24)),

               Text(
                "Preparing Geeta Audio",
                style: TextStyle(
                  fontSize: scaleWidth(context, 26),
                  fontWeight: FontWeight.w600,
                ),
              ),

             SizedBox(height: scaleHeight(context, 10)),

              const Text(
                "Downloading all shloks for offline listening",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: scaleHeight(context, 30)),

              CircularProgressIndicator(
                backgroundColor:Colors.grey.shade300 ,
                color:const Color(0xFF3A86FF) ,
              ),
              SizedBox(height: scaleHeight(context, 30)),

              // 🔵 Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: scaleHeight(context, 12),
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF3A86FF),
                ),
              ),

             SizedBox(height: scaleHeight(context, 16)),

              Text(
                "$completed / $total files - Total 167Mb",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            
              Text(
                "- Restart app if it gets stuck -",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
