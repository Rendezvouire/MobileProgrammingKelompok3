String formatCoords(double latitude, double longitude) {
  return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}

String formatDate(DateTime? date) {
  if (date == null) return '-';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  String two(int n) => n.toString().padLeft(2, '0');
  return '${date.day} ${months[date.month - 1]} ${date.year}, '
      '${two(date.hour)}.${two(date.minute)}';
}
