import '../utils/app_constants.dart';

class SettingsController {
  // Nilai yang SUDAH tersimpan & dipakai game
  int _maxScore = AppConstants.defaultMaxScore;
  bool _deuceEnabled = false;

  // Nilai sementara (draft) selagi user masih di layar Pengaturan
  int _draftMaxScore = AppConstants.defaultMaxScore;
  bool _draftDeuceEnabled = false;
  bool _applyToActiveMatch = false; // checkbox "Status Pertandingan"

  int get maxScore => _maxScore;
  bool get deuceEnabled => _deuceEnabled;
  int get draftMaxScore => _draftMaxScore;
  bool get draftDeuceEnabled => _draftDeuceEnabled;
  bool get applyToActiveMatch => _applyToActiveMatch;

  void increaseDraftMaxScore() {
    if (_draftMaxScore < AppConstants.maxMaxScore) _draftMaxScore++;
  }

  void decreaseDraftMaxScore() {
    if (_draftMaxScore > AppConstants.minMaxScore) _draftMaxScore--;
  }

  void selectPreset(int presetScore) {
    _draftMaxScore = presetScore;
  }

  void setDraftDeuce(bool value) {
    _draftDeuceEnabled = value;
  }

  void setApplyToActiveMatch(bool value) {
    _applyToActiveMatch = value;
  }

  /// Dipanggil saat tombol "SIMPAN PENGATURAN" ditekan
  String? saveSettings() {
    if (_draftMaxScore < AppConstants.minMaxScore ||
        _draftMaxScore > AppConstants.maxMaxScore) {
      return 'Skor harus antara ${AppConstants.minMaxScore} dan ${AppConstants.maxMaxScore}';
    }
    _maxScore = _draftMaxScore;
    _deuceEnabled = _draftDeuceEnabled;
    return null; // null = berhasil disimpan
  }

  /// Kalau user keluar tanpa simpan, draft batal
  void discardDraft() {
    _draftMaxScore = _maxScore;
    _draftDeuceEnabled = _deuceEnabled;
  }

  void resetToDefault() {
    _maxScore = AppConstants.defaultMaxScore;
    _deuceEnabled = false;
    discardDraft();
  }
}