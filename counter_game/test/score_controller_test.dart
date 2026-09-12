void main() {
  group('ScoreController', () {
    late ScoreController controller;

    setUp(() {
      controller = ScoreController();
    });

    test('Initial score should be 0 for both players', () {
      expect(controller.player1Score, 0);
      expect(controller.player2Score, 0);
    });

    test('Player 1 score should increase by 1', () {
      controller.addPlayer1Point();

      expect(controller.player1Score, 1);
      expect(controller.player2Score, 0);
    });

    test('Player 2 score should increase by 1', () {
      controller.addPlayer2Point();

      expect(controller.player1Score, 0);
      expect(controller.player2Score, 1);
    });

    test('Player 1 can score multiple points', () {
      controller.addPlayer1Point();
      controller.addPlayer1Point();
      controller.addPlayer1Point();

      expect(controller.player1Score, 3);
    });

    test('Player 2 can score multiple points', () {
      controller.addPlayer2Point();
      controller.addPlayer2Point();
      controller.addPlayer2Point();

      expect(controller.player2Score, 3);
    });

    test('Player 1 and Player 2 scores are independent', () {
      controller.addPlayer1Point();
      controller.addPlayer1Point();

      controller.addPlayer2Point();

      expect(controller.player1Score, 2);
      expect(controller.player2Score, 1);
    });

    test('Player 1 score can be set manually', () {
      controller.setPlayer1Score(5);

      expect(controller.player1Score, 5);
    });

    test('Player 2 score can be set manually', () {
      controller.setPlayer2Score(7);

      expect(controller.player2Score, 7);
    });

    test('Negative Player 1 score should be rejected', () {
      controller.setPlayer1Score(-1);

      expect(controller.player1Score, 0);
    });

    test('Negative Player 2 score should be rejected', () {
      controller.setPlayer2Score(-1);

      expect(controller.player2Score, 0);
    });

    test('Reset should set both scores to 0', () {
      controller.addPlayer1Point();
      controller.addPlayer1Point();
      controller.addPlayer2Point();

      controller.resetScore();

      expect(controller.player1Score, 0);
      expect(controller.player2Score, 0);
    });
  });
}