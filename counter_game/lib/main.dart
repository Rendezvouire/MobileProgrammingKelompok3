import 'package:flutter/material.dart';

void main() {
  runApp(const ScoreTrackerApp());
}

class ScoreTrackerApp extends StatelessWidget {
  const ScoreTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Point Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF7F9),
        fontFamily: 'sans-serif',
      ),
      home: const ScoreCounterScreen(),
    );
  }
}

class ScoreCounterScreen extends StatefulWidget {
  const ScoreCounterScreen({super.key});

  @override
  State createState() => _ScoreCounterScreenState();
}

class _ScoreCounterScreenState extends State {
  static const Color accentPink = Color(0xFFE91E63);
  static const Color softBorder = Color(0xFFFCE4EC);

  String player1Name = 'Player 1';
  String player2Name = 'Player 2';
  int targetScore = 21;
  bool isDeuceEnabled = true;

  int score1 = 0;
  int score2 = 0;
  int servingPlayer = 1;

  bool get isDeuceActive =>
      isDeuceEnabled &&
      score1 >= (targetScore - 1) &&
      score2 >= (targetScore - 1) &&
      !isMatchFinished;

  bool get isMatchFinished {
    if (!isDeuceEnabled) {
      return score1 >= targetScore || score2 >= targetScore;
    }

    if (score1 >= targetScore || score2 >= targetScore) {
      if (score1 == 30 || score2 == 30) return true;
      if ((score1 - score2).abs() >= 2) return true;
    }
    return false;
  }

  String get matchWinner => score1 > score2 ? player1Name : player2Name;

  void _incrementScore(int player) {
    if (isMatchFinished) return;
    setState(() {
      if (player == 1) {
        score1++;
      } else {
        score2++;
      }
      servingPlayer = player;
    });
  }

  void _decrementScore(int player) {
    setState(() {
      if (player == 1 && score1 > 0) score1--;
      if (player == 2 && score2 > 0) score2--;
    });
  }

  void _resetScores() {
    setState(() {
      score1 = 0;
      score2 = 0;
      servingPlayer = 1;
    });
  }

  void _openSettings() {
    final name1Controller = TextEditingController(text: player1Name);
    final name2Controller = TextEditingController(text: player2Name);
    final score1Controller = TextEditingController(text: score1.toString());
    final score2Controller = TextEditingController(text: score2.toString());
    int tempTarget = targetScore;
    int tempServer = servingPlayer;
    bool tempDeuce = isDeuceEnabled;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setSettingsState) {
              return Scaffold(
                backgroundColor: const Color(0xFFFFF7F9),
                body: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFFFDE8EF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: accentPink,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CONFIGURATION',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: accentPink,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: accentPink,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.tune_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _buildSectionCard(
                                    title: 'TARGET WINNING SCORE',
                                    badge: 'Game Point',
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF7F9),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: softBorder, width: 1),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  if (tempTarget > 1) {
                                                    setSettingsState(
                                                        () => tempTarget--);
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  minimumSize:
                                                      const Size(52, 52),
                                                  padding: EdgeInsets.zero,
                                                  side: const BorderSide(
                                                      color: accentPink,
                                                      width: 1.5),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Icon(
                                                    Icons.remove_rounded,
                                                    color: accentPink,
                                                    size: 24),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    '$tempTarget',
                                                    style: const TextStyle(
                                                      fontSize: 42,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color(0xFF0F172A),
                                                      height: 1,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'POINTS TO WIN',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color(0xFF64748B),
                                                      letterSpacing: 0.8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setSettingsState(
                                                      () => tempTarget++);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size(52, 52),
                                                  padding: EdgeInsets.zero,
                                                  backgroundColor: accentPink,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: const Icon(
                                                    Icons.add_rounded,
                                                    color: Colors.white,
                                                    size: 24),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildPresetCard(
                                                score: 21,
                                                title: 'Badminton',
                                                isSelected: tempTarget == 21,
                                                onTap: () => setSettingsState(
                                                    () => tempTarget = 21),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: _buildPresetCard(
                                                score: 25,
                                                title: 'Volleyball',
                                                isSelected: tempTarget == 25,
                                                onTap: () => setSettingsState(
                                                    () => tempTarget = 25),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: _buildPresetCard(
                                                score: 11,
                                                title: 'Table Tennis',
                                                isSelected: tempTarget == 11,
                                                onTap: () => setSettingsState(
                                                    () => tempTarget = 11),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildSectionCard(
                                    title: 'MATCH REGULATIONS',
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF7F9),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                            color: softBorder, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Deuce Rule (2-Point Lead)',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Requires a 2-point margin to win at critical scores',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Switch(
                                            value: tempDeuce,
                                            activeTrackColor: accentPink,
                                            onChanged: (val) {
                                              setSettingsState(
                                                  () => tempDeuce = val);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildSectionCard(
                                    title: 'PLAYERS & POSITION',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: name1Controller,
                                          decoration: InputDecoration(
                                            labelText: 'Player 1 Name',
                                            filled: true,
                                            fillColor: const Color(0xFFFFF7F9),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: softBorder),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: softBorder),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: accentPink),
                                            ),
                                            isDense: true,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: name2Controller,
                                          decoration: InputDecoration(
                                            labelText: 'Player 2 Name',
                                            filled: true,
                                            fillColor: const Color(0xFFFFF7F9),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: softBorder),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: softBorder),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: accentPink),
                                            ),
                                            isDense: true,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        const Text(
                                          'Initial / Current Scores:',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: score1Controller,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'P1 Score',
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFFFF7F9),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: softBorder),
                                                  ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: TextField(
                                                controller: score2Controller,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'P2 Score',
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFFFF7F9),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: softBorder),
                                                  ),
                                                  isDense: true,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        const Text(
                                          'Initial Serve Position:',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      tempServer == 1
                                                          ? accentPink
                                                          : Colors.white,
                                                  side: BorderSide(
                                                    color: tempServer == 1
                                                        ? accentPink
                                                        : softBorder,
                                                    width: 1.5,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                ),
                                                onPressed: () =>
                                                    setSettingsState(
                                                        () => tempServer = 1),
                                                child: Text(
                                                  'Player 1 Serves',
                                                  style: TextStyle(
                                                    color: tempServer == 1
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF64748B),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor:
                                                      tempServer == 2
                                                          ? accentPink
                                                          : Colors.white,
                                                  side: BorderSide(
                                                    color: tempServer == 2
                                                        ? accentPink
                                                        : softBorder,
                                                    width: 1.5,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                ),
                                                onPressed: () =>
                                                    setSettingsState(
                                                        () => tempServer = 2),
                                                child: Text(
                                                  'Player 2 Serves',
                                                  style: TextStyle(
                                                    color: tempServer == 2
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF64748B),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    player1Name =
                                        name1Controller.text.trim().isEmpty
                                            ? 'Player 1'
                                            : name1Controller.text.trim();
                                    player2Name =
                                        name2Controller.text.trim().isEmpty
                                            ? 'Player 2'
                                            : name2Controller.text.trim();
                                    score1 =
                                        int.tryParse(score1Controller.text) ??
                                            score1;
                                    score2 =
                                        int.tryParse(score2Controller.text) ??
                                            score2;
                                    targetScore = tempTarget;
                                    servingPlayer = tempServer;
                                    isDeuceEnabled = tempDeuce;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentPink,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.done_all_rounded,
                                    color: Colors.white, size: 20),
                                label: const Text(
                                  'Apply Configurations',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: accentPink,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'LIVE MATCH',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: accentPink,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Score Counter',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _openSettings,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFDE8EF),
                          padding: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: accentPink,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildPlayerTile(
                    name: player1Name,
                    score: score1,
                    isServer: servingPlayer == 1,
                    onAdd: () => _incrementScore(1),
                    onMinus: () => _decrementScore(1),
                    onSetServe: () => setState(() => servingPlayer = 1),
                  ),
                  const SizedBox(height: 16),
                  _buildPlayerTile(
                    name: player2Name,
                    score: score2,
                    isServer: servingPlayer == 2,
                    onAdd: () => _incrementScore(2),
                    onMinus: () => _decrementScore(2),
                    onSetServe: () => setState(() => servingPlayer = 2),
                  ),
                  const SizedBox(height: 24),
                  if (!isMatchFinished) ...[
                    if (isDeuceActive)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: accentPink.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '⚡ DEUCE POINT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: accentPink,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '• Need 2 pts lead (Cap: 30)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'First to reach $targetScore points wins the game',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetScores,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: softBorder, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.restart_alt_rounded,
                                color: accentPink, size: 19),
                            label: const Text(
                              'Reset Game',
                              style: TextStyle(
                                color: accentPink,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _openSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentPink,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.settings_outlined,
                                color: Colors.white, size: 18),
                            label: const Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: softBorder, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: accentPink.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFDE8EF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events_rounded,
                              color: accentPink,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'GAME OVER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$matchWinner Wins!',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: accentPink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Final Score: ' +
                                score1.toString() +
                                ' - ' +
                                score2.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _resetScores,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentPink,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.refresh_rounded,
                                  color: Colors.white, size: 20),
                              label: const Text(
                                'Play Again',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTile({
    required String name,
    required int score,
    required bool isServer,
    required VoidCallback onAdd,
    required VoidCallback onMinus,
    required VoidCallback onSetServe,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isServer ? accentPink.withValues(alpha: 0.35) : softBorder,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: onSetServe,
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isServer ? accentPink : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isServer
                            ? Icons.sports_tennis_rounded
                            : Icons.shield_outlined,
                        size: 13,
                        color:
                            isServer ? Colors.white : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isServer ? 'SERVING' : 'DEFENDING',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color:
                              isServer ? Colors.white : const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  height: 1.0,
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: isMatchFinished ? null : onMinus,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: softBorder, width: 1.5),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.remove_rounded,
                        color: accentPink, size: 22),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isMatchFinished ? null : onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPink,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '+1',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isMatchFinished
                            ? const Color(0xFF94A3B8)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? badge,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: softBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: accentPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accentPink,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8EF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentPink,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildPresetCard({
    required int score,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentPink : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accentPink : softBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
