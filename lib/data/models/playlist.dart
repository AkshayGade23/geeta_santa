import 'package:geeta_santha/data/models/shlok.dart';

class Playlist {

    final int chapterNo;
    final String name;
    final List<Shlok> shloks;
    final int count;
    Playlist({required this.chapterNo,required this.name, required this.shloks, required this.count});

}