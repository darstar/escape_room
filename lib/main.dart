import 'dart:async';
import 'package:flutter/material.dart';

Map<String, Color> colors = {
  'background': const Color(0xFF121212),
  'primary': const Color(0xFF1A3059),
  'warning': const Color(0xFFB71C1C),
  'success': const Color.fromARGB(255, 10, 191, 103),
  'secondary': const Color(0xFFDDE3E7),
  'orange': const Color(0xFFE34D25),
};

void main() {
  runApp(const MarchEscapeRoomApp());
}

class MarchEscapeRoomApp extends StatelessWidget {
  const MarchEscapeRoomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project MARCH - Software Diagnostic',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1A3059), // MARCH Green vibe
      ),
      home: const StartWarningScreen(),
    );
  }
}

// START SCREEN: Warning with revealable instructions
class StartWarningScreen extends StatefulWidget {
  const StartWarningScreen({Key? key}) : super(key: key);

  @override
  State<StartWarningScreen> createState() => _StartWarningScreenState();
}

class _StartWarningScreenState extends State<StartWarningScreen> {
  bool _showInstructions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors['warning'],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning, color: Colors.white, size: 36),
                    SizedBox(width: 12),
                    Text(
                      'WARNING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.warning, color: Colors.white, size: 36),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors['secondary'],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    'HELP! The exoskeleton\'s right leg is not working as expected. We have recieved some corrupted data from the exo. Can you spot the mistakes in the data?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _showInstructions = !_showInstructions;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 900),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors['secondary'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _showInstructions
                                ? 'Hide game instructions'
                                : 'Tap here for game instructions',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          _showInstructions
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 800),
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors['secondary'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'Instructions:\n'
                      'The exoskeleton has sent some data from three critical sensors: angle, torque and current. However, some fo the data seems to be corrupted.'
                      'The data channels got mixed up during transmission, and some of the signals are noisy. Can you figure out which signal corresponds to which sensor, and identify the anomalies in the data?\n\n'
                      '1. Drag the telemetry cards into the three slots on the right.\n'
                      '2. Match ANGLES, CURRENT, and TORQUE to the correct signals.\n'
                      '3. Use the reference plot on the left to compare the shapes.\n'
                      '4. Some channels are intentionally noisy, so look for the strongest pattern match.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  crossFadeState: _showInstructions
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 220),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colors['orange'],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const DiagnosticScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'BEGIN DIAGNOSTIC',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({Key? key}) : super(key: key);

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  // Puzzle state mapping: Target Slot -> Placed Card ID
  final Map<String, String?> _slots = {
    'ANGLES': null,
    'CURRENT': null,
    'TORQUE': null,
  };

  // Available cards remaining in the deck
  List<Map<String, String>> _availableCards = [
    {'id': 'A', 'asset': 'assets/card_a.png', 'label': 'Packet 0X4A'},
    {'id': 'B', 'asset': 'assets/card_b.png', 'label': 'Packet 0X4B'},
    {'id': 'C', 'asset': 'assets/card_c.png', 'label': 'Packet 0X4C'},
    {'id': 'D', 'asset': 'assets/card_d.png', 'label': 'Packet 0X4D'},
  ];

  // Penalty Timer logic
  int _penaltySecondsRemaining = 0;
  Timer? _penaltyTimer;
  bool _hasEscaped = false;

  void _startPenalty() {
    setState(() {
      _penaltySecondsRemaining = 10; // 10 seconds
    });
    _penaltyTimer?.cancel();
    _penaltyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_penaltySecondsRemaining > 0) {
        setState(() {
          _penaltySecondsRemaining--;
        });
      } else {
        _penaltyTimer?.cancel();
      }
    });
  }

  void _verifyConfiguration() {
    // Correct solution mapping:
    // Slot 'ANGLES'  -> Card 'A'
    // Slot 'CURRENT' -> Card 'C'
    // Slot 'TORQUE'  -> Card 'B'
    if (_slots['ANGLES'] == 'A' &&
        _slots['CURRENT'] == 'C' &&
        _slots['TORQUE'] == 'B') {
      setState(() {
        _hasEscaped = true;
      });
      _penaltyTimer?.cancel();
    } else {
      // Wrong layout -> Trigger lock and empty slots back to pool
      _startPenalty();
      setState(() {
        _slots.forEach((key, value) {
          if (value != null) {
            // Find card metadata to put back in pool
            final cardId = value;
            final assetPath = cardId == 'A'
                ? 'card_a'
                : cardId == 'B'
                ? 'card_b'
                : cardId == 'C'
                ? 'card_c'
                : 'card_d';
            _availableCards.add({
              'id': cardId,
              'asset': 'assets/$assetPath.png',
              'label': 'Packet 0X4${cardId}',
            });
          }
        });
        _slots['ANGLES'] = null;
        _slots['CURRENT'] = null;
        _slots['TORQUE'] = null;
      });
    }
  }

  @override
  void dispose() {
    _penaltyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasEscaped) {
      return const EscapeSuccessScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // LEFT COLUMN: Master Reference Sheet View
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "MASTER REFERENCE GAIT PROFILE",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors['primary'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Image.asset(
                          'assets/reference.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const VerticalDivider(width: 1, color: Colors.white24),

              // RIGHT COLUMN: Workspace & Target Slots
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "DIAGNOSTIC ARCHITECTURE PATCH PANEL",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors['orange'],
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Target Slots Configuration Layout
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 72,
                                child: _buildTargetSlot(
                                  'ANGLES',
                                  _slots['ANGLES'],
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 72,
                                child: _buildTargetSlot(
                                  'CURRENT',
                                  _slots['CURRENT'],
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 72,
                                child: _buildTargetSlot(
                                  'TORQUE',
                                  _slots['TORQUE'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 22, color: Colors.white24),

                      // Card Staging Area (Deck)
                      Text(
                        "CORRUPTED DATA PACKETS",
                        style: TextStyle(color: colors['secondary']),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 135,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors['secondary'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _availableCards.map((cardMap) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                ),
                                child: Draggable<Map<String, String>>(
                                  data: cardMap,
                                  feedback: _buildDraggableCard(
                                    cardMap,
                                    isDragging: true,
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: _buildDraggableCard(cardMap),
                                  ),
                                  child: _buildDraggableCard(cardMap),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Run Compile Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors['success'],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                        ),
                        onPressed:
                            (_slots.values.contains(null) ||
                                _penaltySecondsRemaining > 0)
                            ? null
                            : _verifyConfiguration,
                        child: const Text(
                          "COMPILE AND CHECK OUTPUT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // OVERLAY: System Lockout (2 Minute Penalty)
          if (_penaltySecondsRemaining > 0)
            Container(
              color: Colors.black.withOpacity(0.92),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.gpp_bad,
                      color: Colors.redAccent,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "FIRMWARE COMPILATION CRASHED",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Input array contains unhandled anomalies. Control loop locked down to avoid motor burnout.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "${(_penaltySecondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_penaltySecondsRemaining % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 72,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "COOLING DOWN SYSTEM REGULATORS...",
                      style: TextStyle(color: Colors.grey, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTargetSlot(String slotName, String? cardId) {
    return DragTarget<Map<String, String>>(
      onAccept: (cardMap) {
        setState(() {
          _slots[slotName] = cardMap['id'];
          _availableCards.removeWhere((item) => item['id'] == cardMap['id']);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 600,
          decoration: BoxDecoration(
            color: cardId != null
                ? Colors.transparent
                : Colors.white.withOpacity(0.03),
            border: Border.all(
              color: candidateData.isNotEmpty ? Colors.blue : Colors.white24,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slotName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: cardId != null
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  'assets/card_${cardId.toLowerCase()}.png',
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  filterQuality: FilterQuality.high,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _slots[slotName] = null;
                                  _availableCards.add({
                                    'id': cardId,
                                    'asset':
                                        'assets/card_${cardId.toLowerCase()}.png',
                                    'label': 'Packet 0X4$cardId',
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Icon(
                          Icons.add_to_queue,
                          color: Colors.white12,
                          size: 40,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableCard(
    Map<String, String> cardMap, {
    bool isDragging = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 130,
        height:
            180, // 💡 ADDED: Explicit height fixes the layout unbound crash!
        child: GestureDetector(
          onTap: () => _showExpandedImageDialog(cardMap),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF212121),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDragging ? Colors.blue : Colors.white38,
              ),
              boxShadow: isDragging
                  ? [const BoxShadow(color: Colors.black54, blurRadius: 10)]
                  : [],
            ),
            child: Column(
              children: [
                Text(
                  cardMap['label']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          cardMap['asset']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: const Text(
                            '🔍',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExpandedImageDialog(Map<String, String> cardMap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A3059),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Expanded Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(cardMap['asset']!, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                // Instructions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
                const SizedBox(height: 16),
                // Close Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// SUCCESS SCREEN (THE ESCAPE DEPLOYMENT)
// STAGE 1 SUCCESS - TRANSITION SCREEN
class FirstStageSuccessScreen extends StatelessWidget {
  const FirstStageSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2514), // Dark deep green
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF00E676),
              size: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "PATCH DEPLOYED SUCCESSFULLY",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00E676),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Right-leg kinematics calibrated. Control loop active. Exoskeleton online.",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00E676), width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black38,
              ),
              child: const Text(
                "ESCAPE CODE: MARCH-DEPL-2026",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// STAGE 2: KERNEL BITSTREAM COMPILE - LOGIC GATES PUZZLE
class EscapeSuccessScreen extends StatefulWidget {
  const EscapeSuccessScreen({Key? key}) : super(key: key);

  @override
  State<EscapeSuccessScreen> createState() => _EscapeSuccessScreenState();
}

class _EscapeSuccessScreenState extends State<EscapeSuccessScreen> {
  // User inputs for the logic gates
  bool? inputA; // Angle state
  bool? inputB; // Current state
  bool? inputC; // Torque state

  int _penaltySecondsRemaining = 0;
  Timer? _penaltyTimer;
  bool _showFinalUnlock = false;
  bool _triggeredError = false;

  void _startPenalty() {
    setState(() {
      _penaltySecondsRemaining = 10;
    });

    _penaltyTimer?.cancel();
    _penaltyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_penaltySecondsRemaining > 0) {
        setState(() {
          _penaltySecondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyLogic() {
    // Correct physical deduction states:
    // Input A (Angles out of phase/failed) = false (0)
    // Input B (Current saturated/error triggered) = true (1)
    // Input C (Torque operational/safe) = false (0)
    if (inputA == false && inputB == true && inputC == false) {
      setState(() {
        _showFinalUnlock = true;
        _triggeredError = false;
      });
      _penaltyTimer?.cancel();
    } else {
      setState(() {
        _triggeredError = true;
      });
      _startPenalty();
    }
  }

  @override
  void dispose() {
    _penaltyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showFinalUnlock) {
      return const FinalDoorCodeScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24),
      body: Stack(
        children: [
          // faint exoskeleton background for Stage 2
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/exo.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.22),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 800,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.terminal, color: Colors.blueAccent, size: 36),
                      SizedBox(width: 15),
                      Text(
                        "STAGE 2: DATA CHANNEL LOGIC",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Use the plots to decide what each stream is doing in plain terms. Choose 0 or 1 based on the hints and your deductions about the exoskeleton's state. Then execute the bitwise function to see if you can compile the code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 20),

                  // Dynamic Switch Grid
                  _buildLogicRow(
                    "Stream 0X4A (Angle Data)",
                    "0 = Angle waveform is shifted away from the reference\n1 = Angle waveform lines up with the reference",
                    inputA,
                    (val) => setState(() => inputA = val),
                  ),
                  const SizedBox(height: 15),
                  _buildLogicRow(
                    "Stream 0X4C (Current Data)",
                    "0 = Current stays in the normal range\n1 = Current limit is exceeded",
                    inputB,
                    (val) => setState(() => inputB = val),
                  ),
                  const SizedBox(height: 15),
                  _buildLogicRow(
                    "Stream 0X4B (Torque Data)",
                    "0 = Torque fails the safe-pattern check\n1 = Torque follows the gait pattern cleanly",
                    inputC,
                    (val) => setState(() => inputC = val),
                  ),

                  const SizedBox(height: 5),

                  if (_triggeredError && _penaltySecondsRemaining == 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "LOGIC COMPILATION ERROR: Output evaluates to 0 (SYSTEM_HALT)",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                    ),
                    onPressed:
                        (_penaltySecondsRemaining > 0 ||
                            inputA == null ||
                            inputB == null ||
                            inputC == null)
                        ? null
                        : _verifyLogic,
                    child: const Text(
                      "EXECUTE BITWISE FUNCTION",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_penaltySecondsRemaining > 0)
            Container(
              color: Colors.black.withOpacity(0.88),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.gpp_bad,
                      color: Colors.redAccent,
                      size: 88,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "LOGIC COMPILATION CRASHED",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Access to the final bitstream is temporarily locked.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "${(_penaltySecondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_penaltySecondsRemaining % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 64,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogicRow(
    String title,
    String subtitle,
    bool? currentVal,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ChoiceChip(
                label: const Text(" BIT 0 "),
                selected: currentVal == false,
                selectedColor: Colors.red.withOpacity(0.4),
                onSelected: (selected) {
                  if (selected) onChanged(false);
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text(" BIT 1 "),
                selected: currentVal == true,
                selectedColor: Colors.green.withOpacity(0.4),
                onSelected: (selected) {
                  if (selected) onChanged(true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// THE FINAL ESCAPE SCREEN REVEALING THE SINGLE DIGIT '1'
class FinalDoorCodeScreen extends StatefulWidget {
  const FinalDoorCodeScreen({Key? key}) : super(key: key);

  @override
  State<FinalDoorCodeScreen> createState() => _FinalDoorCodeScreenState();
}

class _FinalDoorCodeScreenState extends State<FinalDoorCodeScreen> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              _revealed = true;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_open, color: Color(0xFF00E676), size: 80),
              const SizedBox(height: 20),
              const Text(
                "FIRMWARE INJECTED AND COMPILED",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E676),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "FINAL REPOSITORY SYSTEM KEY:",
                style: TextStyle(color: Colors.grey, letterSpacing: 1),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  border: Border.all(color: const Color(0xFF00E676), width: 3),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    _revealed ? "1" : "TAP TO REVEAL",
                    key: ValueKey<bool>(_revealed),
                    style: TextStyle(
                      fontSize: _revealed ? 140 : 28,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: _revealed ? 0 : 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _revealed
                    ? "ACCESS GRANTED. EXOSKELETON FULLY OPERATIONAL. Final key value revealed"
                    : "Tap the panel to reveal the final bit.",
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
