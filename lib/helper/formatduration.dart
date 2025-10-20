String formatDuration(int? totalMinutes) {
  // Jika data null atau 0, kembalikan string kosong
  if (totalMinutes == null || totalMinutes <= 0) {
    return '';
  }

  // Jika kurang dari 60 menit
  if (totalMinutes < 60) {
    return '$totalMinutes menit';
  }

  // Jika 60 menit atau lebih
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  // Jika pas (contoh: 120 menit -> 2 jam)
  if (minutes == 0) {
    return '$hours jam';
  }

  // Jika ada sisa menit (contoh: 95 menit -> 1 jam 35 menit)
  return '$hours jam $minutes menit';
}