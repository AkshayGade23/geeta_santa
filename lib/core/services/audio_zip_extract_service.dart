import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class AudioZipExtractService {

  Future<void> extractZip({
    required String zipPath,
    required String destinationPath,
  }) async {
    final zipFile = File(zipPath);
    final bytes = await zipFile.readAsBytes();

    final archive = ZipDecoder().decodeBytes(bytes);

    print("1 .Extracted zip - ----- $zipPath");

    for (final file in archive) {
      final filename = file.name;
      print("-----  .Extracted file path - ----- $filename");
      final outPath = '$destinationPath/$filename';

      if (file.isFile) {
        final outFile = File(outPath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(outPath).create(recursive: true);
      }
    }
  }
}
