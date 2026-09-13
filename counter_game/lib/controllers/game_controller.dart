class GameController {
  int player1Score = 0;
  int player2Score = 0;
  int maxScore = 21;
  bool isDeuceActive = true;
  int? winner; // null jika belum ada yang menang, bernilai 1 atau 2 jika sudah menang

  // Cek apakah game sudah selesai
  bool get isGameOver => winner != null;

  // Tambah poin Player 1
  void addPointPlayer1() {
    if (isGameOver) return;
    player1Score++;
    _checkWinner();
  }

  // Kurang poin Player 1
  void subtractPointPlayer1() {
    if (isGameOver || player1Score <= 0) return;
    player1Score--;
  }

  // Tambah poin Player 2
  void addPointPlayer2() {
    if (isGameOver) return;
    player2Score++;
    _checkWinner();
  }

  // Kurang poin Player 2
  void subtractPointPlayer2() {
    if (isGameOver || player2Score <= 0) return;
    player2Score--;
  }

  // Logika penentuan pemenang (termasuk aturan Deuce / selisih 2 poin)
  void _checkWinner() {
    if (isDeuceActive) {
      // Jika deuce aktif, wajib mencapai target DAN selisih minimal 2 poin
      if (player1Score >= maxScore && player1Score - player2Score >= 2) {
        winner = 1;
      } else if (player2Score >= maxScore && player2Score - player1Score >= 2) {
        winner = 2;
      }
    } else {
      // Jika deuce non-aktif, siapa yang duluan mencapai maxScore langsung menang
      if (player1Score >= maxScore) {
        winner = 1;
      } else if (player2Score >= maxScore) {
        winner = 2;
      }
    }
  }

  // Mengubah target skor maksimal dan mereset permainan
  void setMaxScore(int newMaxScore, {bool deuce = true}) {
    maxScore = newMaxScore;
    isDeuceActive = deuce;
    resetGame();
  }

  // Reset skor dan status game kembali ke awal
  void resetGame() {
    player1Score = 0;
    player2Score = 0;
    winner = null;
  }
}
