import 'dart:io';

class AudioStorageService {
  static const String rootFolder = "geeta_audio";

  Future<Directory> _getRootDir() async {
    final mediaDirPath = '/storage/emulated/0/Android/media/com.akshay.geetasantha/Santha/Santha_audio';
    final mediaDir = Directory(mediaDirPath);

  if (!await mediaDir.exists()) {
    await mediaDir.create(recursive: true);
  }

  return mediaDir;
  }

 Future<String> getShlokPath(int? chapterNo, int? shlokNo) async {
  if (chapterNo == null || shlokNo == null) {
    throw ArgumentError("chapterNo and shlokNo cannot be null");
  }

  final root = await _getRootDir();

  // Add leading 0 if single digit
  String chapterStr = chapterNo.toString().padLeft(2, '0');
  String shlokStr = shlokNo.toString().padLeft(2, '0');

  final chapterDir = Directory("${root.path}/chapter$chapterStr");

  if (!await chapterDir.exists()) {
    await chapterDir.create(recursive: true);
  }

  final file = File("${chapterDir.path}/${chapterStr}_$shlokStr.m4a");

  return file.path;
}

  Future<bool> isShlokDownloaded(int chapterNo, int shlokNo) async {
    final path = await getShlokPath(chapterNo, shlokNo);
    return File(path).exists();
  }



   /// 🔥 MAIN CHECK FUNCTION (USED IN SPLASH)
  Future<bool> areAllFilesPresent() async {
    for (int chapter = 1; chapter <= 18; chapter++) {
      final shlokCount = _shlokCount(chapter);

      for (int shlok = 1; shlok <= shlokCount; shlok++) {
        final exists = await isShlokDownloaded(chapter, shlok);
        if (!exists) {
          return false; // ❌ missing file
        }
      }
    }
    return true; // ✅ all present
  }

  
  int _shlokCount(int chapter) {
    const map = {
      1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47,
      7: 30, 8: 28, 9: 34, 10: 42, 11: 55, 12: 20,
      13: 35, 14: 27, 15: 20, 16: 24, 17: 28, 18: 78,
    };
    return map[chapter]!;
  }


  Future<Directory> getRootDir() async {
  return _getRootDir();
}

// temp zip path
Future<String> getTempZipPath(String chapterStr) async {
  final root = await _getRootDir();
  final tempDir = Directory('${root.path}/temp');

  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  return '${tempDir.path}/chapter$chapterStr.zip';
}

// check entire chapter
Future<bool> isChapterDownloaded(int chapter) async {
  final shlokCount = _shlokCount(chapter);

  for (int shlok = 1; shlok <= shlokCount; shlok++) {
    final exists = await isShlokDownloaded(chapter, shlok);
    if (!exists) return false;
  }
  return true;
}
}
