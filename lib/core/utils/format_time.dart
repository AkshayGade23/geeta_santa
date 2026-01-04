String formatTime(double seconds) {
    int min = seconds ~/ 60;
    int sec = (seconds % 60).toInt();
    return "${min.toString()}:${sec.toString().padLeft(2, '0')}";
  }