class DateFormatter {
  static String _stripTimezone(String isoDate) {
    if (isoDate.length >= 19) {
      return isoDate.substring(0, 19);
    }
    return isoDate;
  }

  static String formatTime(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final cleanIso = _stripTimezone(isoDate);
      final dt = DateTime.parse(cleanIso);
      String pad(int n) => n.toString().padLeft(2, '0');

      return "${pad(dt.hour)}:${pad(dt.minute)}";
    } catch (e) {
      return "-";
    }
  }

  static String formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final cleanIso = _stripTimezone(isoDate);
      final dt = DateTime.parse(cleanIso);
      final List<String> months = [
        "",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Ags",
        "Sep",
        "Okt",
        "Nov",
        "Des",
      ];
      final List<String> days = [
        "Min",
        "Sen",
        "Sel",
        "Rab",
        "Kam",
        "Jum",
        "Sab",
      ];
      int dayIndex = dt.weekday == 7 ? 0 : dt.weekday;

      String dayName = days[dayIndex];
      String monthName = months[dt.month];

      return "$dayName, ${dt.day} $monthName ${dt.year}";
    } catch (e) {
      return "-";
    }
  }
}
