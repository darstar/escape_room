import 'dart:async';
import 'package:flutter/material.dart';

// Unified UI Color Palette
final Map<String, Color> colors = {
  'background': const Color(0xFF0F172A), // Deep Slate Blue
  'surface': const Color(0xFF1E293B), // Lighter Slate for cards/containers
  'primary': const Color(0xFF38BDF8), // Electric Cyan
  'warning': const Color(0xFF991B1B), // Deep Warning Red
  'warningLight': const Color(0xFFEF4444), // Bright Accent Red
  'success': const Color(0xFF10B981), // Neon Matrix Green
  'textMain': const Color(0xFFF8FAFC), // Off-White for crisp reading
  'textMuted': const Color(0xFF94A3B8), // Muted Grey for subtext
  'orange': const Color(0xFFF97316), // UI Accent Orange
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: colors['background'],
        primaryColor: colors['primary'],
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
      backgroundColor: colors['background'],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors['warning'],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors['warningLight']!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors['textMain'],
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'SYSTEM ANOMALY DETECTED',
                          style: TextStyle(
                            color: colors['textMain'],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.warning_amber_rounded,
                          color: colors['textMain'],
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors['surface'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors['warningLight']!.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      'HELP! The exoskeleton\'s right leg is not working as expected. We have received some corrupted data from the exo. Can you spot the mistakes in the data?',
                      style: TextStyle(
                        color: colors['textMain'],
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _showInstructions = !_showInstructions;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors['surface'],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors['primary']!.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.menu_book, color: colors['primary']),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _showInstructions
                                  ? 'Hide game instructions'
                                  : 'Tap here for game instructions',
                              style: TextStyle(
                                color: colors['textMain'],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            _showInstructions
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: colors['textMuted'],
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
                        color: colors['surface'],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors['textMuted']!.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Instructions:\n'
                        'The exoskeleton has sent some data from three critical sensors: angle, torque and current. However, some of the data seems to be corrupted. '
                        'The data channels got mixed up during transmission, and some of the signals are noisy. Can you figure out which signal corresponds to which sensor, and identify the anomalies in the data?\n\n'
                        '1. Drag the telemetry cards into the three slots on the right.\n'
                        '2. Match ANGLES, CURRENT, and TORQUE to the correct signals.\n'
                        '3. Use the reference plot on the left to compare the shapes.\n'
                        '4. Some channels are intentionally noisy, so look for the strongest pattern match.',
                        style: TextStyle(
                          color: colors['textMuted'],
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
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors['orange'],
                      foregroundColor: colors['textMain'],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
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
  final Map<String, String?> _slots = {
    'ANGLES': null,
    'CURRENT': null,
    'TORQUE': null,
  };

  List<Map<String, String>> _availableCards = [
    {'id': 'A', 'asset': 'assets/card_a.png', 'label': 'Packet 0X4A'},
    {'id': 'B', 'asset': 'assets/card_b.png', 'label': 'Packet 0X4B'},
    {'id': 'C', 'asset': 'assets/card_c.png', 'label': 'Packet 0X4C'},
    {'id': 'D', 'asset': 'assets/card_d.png', 'label': 'Packet 0X4D'},
  ];

  int _penaltySecondsRemaining = 0;
  Timer? _penaltyTimer;
  bool _hasEscaped = false;

  void _startPenalty() {
    setState(() {
      _penaltySecondsRemaining = 71;
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
    if (_slots['ANGLES'] == 'A' &&
        _slots['CURRENT'] == 'C' &&
        _slots['TORQUE'] == 'B') {
      setState(() {
        _hasEscaped = true;
      });
      _penaltyTimer?.cancel();
    } else {
      _startPenalty();
      setState(() {
        _slots.forEach((key, value) {
          if (value != null) {
            final cardId = value;
            _availableCards.add({
              'id': cardId,
              'asset': 'assets/card_${cardId.toLowerCase()}.png',
              'label': 'Packet 0X4$cardId',
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
                  color: const Color(
                    0xFF020617,
                  ), // Near black slate for scope view
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "MASTER REFERENCE GAIT PROFILE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors['primary'],
                          letterSpacing: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors['surface'],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colors['primary']!.withOpacity(0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/reference.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              VerticalDivider(
                width: 1,
                color: colors['textMuted']!.withOpacity(0.2),
              ),

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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors['orange'],
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Target Slots Configuration Layout
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 70,
                                child: _buildTargetSlot(
                                  'ANGLES',
                                  _slots['ANGLES'],
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 70,
                                child: _buildTargetSlot(
                                  'CURRENT',
                                  _slots['CURRENT'],
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 70,
                                child: _buildTargetSlot(
                                  'TORQUE',
                                  _slots['TORQUE'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(
                        height: 10,
                        color: colors['textMuted']!.withOpacity(0.2),
                      ),

                      // Card Staging Area (Deck)
                      Text(
                        "CORRUPTED DATA PACKETS",
                        style: TextStyle(
                          color: colors['textMuted'],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors['surface'],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors['textMuted']!.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _availableCards.map((cardMap) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
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

                      const SizedBox(height: 20),

                      // Run Compile Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors['success'],
                          foregroundColor: colors['background'],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: colors['surface']!
                              .withOpacity(0.5),
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
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // OVERLAY: System Lockout
          if (_penaltySecondsRemaining > 0)
            Container(
              color: Colors.black.withOpacity(0.95),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.report_gmailerrorred_rounded,
                      color: colors['warningLight'],
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "FIRMWARE COMPILATION CRASHED",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colors['warningLight'],
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Input array contains unhandled anomalies. Control loop locked down to avoid motor burnout.",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors['textMuted'],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "${(_penaltySecondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_penaltySecondsRemaining % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 72,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: colors['textMain'],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "COOLING DOWN SYSTEM REGULATORS...",
                      style: TextStyle(
                        color: colors['textMuted'],
                        letterSpacing: 1.5,
                        fontSize: 12,
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

  Widget _buildTargetSlot(String slotName, String? cardId) {
    return DragTarget<Map<String, String>>(
      onAccept: (cardMap) {
        setState(() {
          _slots[slotName] = cardMap['id'];
          _availableCards.removeWhere((item) => item['id'] == cardMap['id']);
        });
      },
      builder: (context, candidateData, rejectedData) {
        bool isHovered = candidateData.isNotEmpty;
        return Container(
          width: 500,
          decoration: BoxDecoration(
            color: cardId != null
                ? colors['surface']
                : colors['surface']!.withOpacity(0.3),
            border: Border.all(
              color: isHovered
                  ? colors['primary']!
                  : (cardId != null
                        ? colors['success']!
                        : colors['textMuted']!.withOpacity(0.3)),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 120,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
                child: Text(
                  slotName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.1,
                    color: cardId != null
                        ? colors['textMain']
                        : colors['textMuted'],
                  ),
                ),
              ),
              Expanded(
                child: cardId != null
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                'assets/card_${cardId.toLowerCase()}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.black12,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.redAccent,
                                ),
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
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          color: colors['textMuted']!.withOpacity(0.3),
                          size: 28,
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
        width: 110,
        height: 130,
        child: GestureDetector(
          onTap: () => _showExpandedImageDialog(cardMap),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF334155), // Explicit distinct card color
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDragging
                    ? colors['primary']!
                    : colors['textMuted']!.withOpacity(0.5),
                width: isDragging ? 2 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  cardMap['label']!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors['textMain'],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.black12,
                            child: Image.asset(
                              cardMap['asset']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.zoom_in,
                            size: 14,
                            color: Colors.white,
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
          backgroundColor: colors['surface'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  cardMap['label']!,
                  style: TextStyle(
                    color: colors['textMain'],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(cardMap['asset']!, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors['primary'],
                    foregroundColor: colors['background'],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CLOSE INSPECTION',
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

// STAGE 2: KERNEL BITSTREAM COMPILE
class EscapeSuccessScreen extends StatefulWidget {
  const EscapeSuccessScreen({Key? key}) : super(key: key);

  @override
  State<EscapeSuccessScreen> createState() => _EscapeSuccessScreenState();
}

class _EscapeSuccessScreenState extends State<EscapeSuccessScreen> {
  bool? inputA;
  bool? inputB;
  bool? inputC;

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
      backgroundColor: colors['background'],
      body: Stack(
        children: [
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.terminal,
                          color: colors['primary'],
                          size: 36,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "STAGE 2: DATA CHANNEL LOGIC",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Use the plots to decide what each stream is doing in plain terms. Choose BIT 0 or BIT 1 based on the hints and your deductions about the exoskeleton's state.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors['textMuted'],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildLogicRow(
                      "Stream 0X4A (Angle Data)",
                      "0 = Angle waveform is shifted away from the reference\n1 = Angle waveform lines up with the reference",
                      inputA,
                      (val) => setState(() => inputA = val),
                    ),
                    const SizedBox(height: 16),
                    _buildLogicRow(
                      "Stream 0X4C (Current Data)",
                      "0 = Current stays in the normal range\n1 = Current limit is exceeded",
                      inputB,
                      (val) => setState(() => inputB = val),
                    ),
                    const SizedBox(height: 16),
                    _buildLogicRow(
                      "Stream 0X4B (Torque Data)",
                      "0 = Torque fails the safe-pattern check\n1 = Torque follows the gait pattern cleanly",
                      inputC,
                      (val) => setState(() => inputC = val),
                    ),

                    const SizedBox(height: 24),

                    if (_triggeredError && _penaltySecondsRemaining == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          "LOGIC COMPILATION ERROR: Output evaluates to 0 (SYSTEM_HALT)",
                          style: TextStyle(
                            color: colors['warningLight'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors['primary'],
                        foregroundColor: colors['background'],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_penaltySecondsRemaining > 0)
            Container(
              color: Colors.black.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_clock,
                      color: colors['warningLight'],
                      size: 88,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "LOGIC COMPILATION CRASHED",
                      style: TextStyle(
                        color: colors['warningLight'],
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Access to the final bitstream is temporarily locked.",
                      style: TextStyle(color: colors['textMuted']),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "${(_penaltySecondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_penaltySecondsRemaining % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 64,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: colors['textMain'],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: colors['surface'],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors['textMuted']!.withOpacity(0.1)),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors['textMain'],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors['textMuted'],
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              ChoiceChip(
                label: const Text(" BIT 0 "),
                selected: currentVal == false,
                selectedColor: colors['warning']!.withOpacity(0.6),
                labelStyle: TextStyle(color: colors['textMain']),
                onSelected: (selected) {
                  if (selected) onChanged(false);
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text(" BIT 1 "),
                selected: currentVal == true,
                selectedColor: colors['success']!.withOpacity(0.6),
                labelStyle: TextStyle(color: colors['textMain']),
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

// THE FINAL ESCAPE SCREEN
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
      backgroundColor: const Color(0xFF020617), // Rich dark finish
      body: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              _revealed = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  color: colors['success'],
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  "FIRMWARE INJECTED & OPERATIONAL",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors['success'],
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "FINAL REPOSITORY SYSTEM KEY:",
                  style: TextStyle(
                    color: colors['textMuted'],
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _revealed ? 80 : 60,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: colors['surface'],
                    border: Border.all(color: colors['success']!, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors['success']!.withOpacity(0.15),
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
                        fontSize: _revealed ? 120 : 20,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        color: colors['textMain'],
                        letterSpacing: _revealed ? 0 : 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _revealed
                      ? "ACCESS GRANTED. EXOSKELETON FULLY OPERATIONAL."
                      : "Tap the panel to reveal the final bit.",
                  style: TextStyle(color: colors['textMuted']),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
