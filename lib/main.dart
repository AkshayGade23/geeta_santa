import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/audio_player_service.dart';
import 'core/services/audio_storage_service.dart';
import 'presentation/providers/playlist_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(const GitaApp());
}

class GitaApp extends StatelessWidget {
  const GitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AudioStorageService()),
        Provider(create: (_) => AudioPlayerService()),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(
            context.read<AudioStorageService>(),
            context.read<AudioPlayerService>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Geeta Santha',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(), // ✅ ENTRY POINT
      ),
    );
  }
}

