class DateFormatter {
  static String formatTime(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      String pad(int n) => n.toString().padLeft(2, '0');
      int hour = dt.hour;
      String period = hour >= 12 ? "PM" : "AM";
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return "${pad(hour)}:${pad(dt.minute)} $period";
    } catch (e) {
      return "-";
    }
  }
}
