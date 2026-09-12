import '../utils/app_constants.dart';

class SettingsController {
  int _maxScore = AppConstants.defaultMaxScore;
  bool _deuceEnabled = false;

  int get maxScore => _maxScore;
  bool get deuceEnabled => _deuceEnabled;

  /// Set maxScore langsung dari input angka.
  /// Return null kalau valid, atau pesan error kalau tidak valid.
  String? setMaxScore(int newScore) {
    if (newScore < AppConstants.minMaxScore ||
        newScore > AppConstants.maxMaxScore) {
      return 'Skor harus antara ${AppConstants.minMaxScore} dan ${AppConstants.maxMaxScore}';
    }
    _maxScore = newScore;
    return null;
  }

  /// Tombol [+] di UI
  void increaseMaxScore() {
    if (_maxScore < AppConstants.maxMaxScore) {
      _maxScore++;
    }
  }

  /// Tombol [-] di UI
  void decreaseMaxScore() {
    if (_maxScore > AppConstants.minMaxScore) {
      _maxScore--;
    }
  }

  /// Preset: Bulu Tangkis / Voli / Tenis Meja
  void applyPreset(int presetScore) {
    setMaxScore(presetScore);
  }

  /// Toggle "Selisih 2 Poin"
  void toggleDeuce(bool value) {
    _deuceEnabled = value;
  }

  /// Kembalikan ke default (dipanggil kalau user reset settings)
  void resetToDefault() {
    _maxScore = AppConstants.defaultMaxScore;
    _deuceEnabled = false;
  }
}