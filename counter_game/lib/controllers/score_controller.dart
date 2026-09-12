class ScoreController extends ChangeNotifier {
  int _player1Score = 0;
  int _player2Score = 0;

  int get player1Score => _player1Score;
  int get player2Score => _player2Score;

  void addPlayer1Point() {
    _player1Score++;
    notifyListeners();
  }

  void addPlayer2Point() {
    _player2Score++;
    notifyListeners();
  }

  void setPlayer1Score(int score) {
    if (score < 0) return;

    _player1Score = score;
    notifyListeners();
  }

  void setPlayer2Score(int score) {
    if (score < 0) return;

    _player2Score = score;
    notifyListeners();
  }

  void resetScore() {
    _player1Score = 0;
    _player2Score = 0;
    notifyListeners();
  }
}
