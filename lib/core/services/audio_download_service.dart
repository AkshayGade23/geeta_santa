import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geeta_santha/core/services/audio_storage_service.dart';
import 'package:geeta_santha/core/services/audio_zip_extract_service.dart';
import 'package:geeta_santha/data/models/download.dart';

class AudioBulkDownloadService {
  final Dio _dio = Dio();
  final AudioStorageService _storage = AudioStorageService();
  final AudioZipExtractService _extractor = AudioZipExtractService();

  static const String _baseUrl =
      'https://github.com/AkshayGade23/geeta_audio/releases/download/v1.0';

  Stream<DownloadProgress> downloadAllWithProgress() async* {
    int completed = 0;
    const total = 18;

    for (int chapter = 1; chapter <= 18; chapter++) {
      final alreadyPresent =
          await _storage.isChapterDownloaded(chapter);

      if (!alreadyPresent) {
        await _downloadAndExtractChapter(chapter);
      }

      completed++;
      yield DownloadProgress(completed, total);
    }
  }

  Future<void> _downloadAndExtractChapter(int chapter) async {
    final chapterStr = chapter.toString().padLeft(2, '0');

    final zipUrl = '$_baseUrl/chapter$chapterStr.zip';

    // print("downlaoding chapter.zip - ----- $zipUrl");

    final zipPath =
        await _storage.getTempZipPath(chapterStr);

    // Download ZIP
    await _dio.download(zipUrl, zipPath);

    // Extract
    final rootDir = await _storage.getRootDir();
    await _extractor.extractZip(
      zipPath: zipPath,
      destinationPath: rootDir.path,
    );
    
    // print("Downloaded and extracted chapter.zip - ----- $zipUrl");
    // Cleanup ZIP
    await File(zipPath).delete();
  }
}










// import 'package:dio/dio.dart';
// import 'package:geeta_santha/core/services/audio_storage_service.dart';
// import 'package:geeta_santha/data/models/download.dart';

// class AudioBulkDownloadService {
//   final Dio _dio = Dio();
//   final AudioStorageService _storage = AudioStorageService();

//   static const String _baseUrl = 'https://github.com/AkshayGade23/geeta_audio/releases/download/v1.0';

//   Stream<DownloadProgress> downloadAllWithProgress() async* {
//     int completed = 0;
//     int total = _totalFiles();

//     for (int chapter = 1; chapter <= 18; chapter++) {
//       final shlokCount = _shlokCount(chapter);

//       for (int shlok = 1; shlok <= shlokCount; shlok++) {
//         final exists =
//             await _storage.isShlokDownloaded(chapter, shlok);

//         if (!exists) {
//           await _downloadShlok(chapter, shlok);
//         }

//         completed++;
//         yield DownloadProgress(completed, total);
//       }
//     }
//   }

//   Future<void> _downloadShlok(int chapter, int shlok) async {
//     final localPath =
//         await _storage.getShlokPath(chapter, shlok);

//     final url =
//         '$_baseUrl/chapter_${chapter.toString().padLeft(2, '0')}/'
//         '${chapter.toString().padLeft(2, '0')}_${shlok.toString().padLeft(2, '0')}.m4a';

//     await _dio.download(url, localPath);
//   }

//   int _totalFiles() {
//     const counts = {
//       1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47,
//       7: 30, 8: 28, 9: 34, 10: 42, 11: 55, 12: 20,
//       13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78,
//     };

//     return counts.values.reduce((a, b) => a + b);
//   }

//   int _shlokCount(int chapter) => _totalFilesMap[chapter]!;

//   static const _totalFilesMap = {
//     1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47,
//     7: 30, 8: 28, 9: 34, 10: 42, 11: 55, 12: 20,
//     13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78,
//   };
// }
