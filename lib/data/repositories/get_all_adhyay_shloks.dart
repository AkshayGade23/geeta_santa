import 'package:geeta_santha/data/models/playlist.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_01.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_02.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_03.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_04.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_05.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_06.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_07.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_08.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_09.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_10.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_11.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_12.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_13.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_14.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_15.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_16.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_17.dart';
import 'package:geeta_santha/core/constants/geeta/adhyay_18.dart';
import 'package:geeta_santha/core/constants/adhay_details.dart';
import 'package:geeta_santha/data/models/shlok.dart';

class GeetaRepository {
   final List<List<Map<String, dynamic>>> all = [
      geeta_01,
      geeta_02,
      geeta_03,
      geeta_04,
      geeta_05,
      geeta_06,
      geeta_07,
      geeta_08,
      geeta_09,
      geeta_10,
      geeta_11,
      geeta_12,
      geeta_13,
      geeta_14,
      geeta_15,
      geeta_16,
      geeta_17,
      geeta_18,
    ];
   GeetaRepository();

   Playlist getAdhyayShloks(int chapterNumber){
      int chapterIndex = chapterNumber-1;
      String name = chapterNames[chapterIndex];
      int count = shlokCounts[chapterIndex];
      List<Shlok> shloks = [];

      for (Map<String, dynamic> verse in all[chapterIndex]) {
        shloks.add(
          Shlok(
            chapterNo: verse['chapter'],
            shlokNo: verse['shlok'],
            text: verse['text'],
            // audioFileName: "${verse['chapter']}_${verse['shlok']}.m4a",
            totalSeconds: 40,
          ),
        );
      }

    return  Playlist(
          chapterNo: chapterNumber,
          name: name,
          shloks: shloks,
          count: count,
        );
  }

  List<Playlist> getAllAdhyayShloks() {
    
    List<Playlist> result = [];

    for (int i = 0; i < 18; i++) {
      int chapterNo = i + 1;
      String name = chapterNames[i];
      int count = shlokCounts[i];
      List<Shlok> shloks = [];

      for (Map<String, dynamic> verse in all[i]) {
        shloks.add(
          Shlok(
            chapterNo: verse['chapter'],
            shlokNo: verse['shlok'],
            text: verse['text'],
            // audioFileName: "${verse['chapter']}_${verse['shlok']}.m4a",
            totalSeconds: 40,
          ),
        );
      }
      result.add(
        Playlist(
          chapterNo: chapterNo,
          name: name,
          shloks: shloks,
          count: count,
        ),
      );
    }

    return result;
  }

  

}
