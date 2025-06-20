// lib/features/mission_log/mission_log_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/data/models/log_entry_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MissionLogScreen extends StatefulWidget {
  const MissionLogScreen({super.key});

  @override
  State<MissionLogScreen> createState() => _MissionLogScreenState();
}

class _MissionLogScreenState extends State<MissionLogScreen> {
  final GameStateController gameState = Get.find<GameStateController>();
  late ScrollController _scrollController;
  late Worker _logChangesWorker;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _logChangesWorker = ever(gameState.logEntries, (_) {
      // --- MODIFICATION 1: We now use a more reliable post-frame callback ---
      // This waits for the UI frame to be built before scrolling,
      // ensuring we know the final size of the new widget.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0.0, // In a reversed list, 0.0 is the bottom.
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _logChangesWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Log'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemCount: gameState.logEntries.length,
                itemBuilder: (context, index) {
                  // --- MODIFICATION 2: SIMPLIFIED LOGIC ---
                  // Because our data list is also reversed (newest items at index 0),
                  // we can just use the index directly here. It's cleaner.
                  final entry = gameState.logEntries[index];
                  
                  return _LogEntryCard(entry: entry)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.1, duration: 400.ms);
                },
              ),
            ),
          ),
          Obx(() {
            if (gameState.unlockedClueIds.contains('final_choice_unlocked')) {
              return gameState.isCaseClosed.value
                  ? _CaseClosedBanner()
                  // Using const for stateless widgets improves performance
                  : const _FinalReportSection(); 
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }
}

// NOTE: The helper widgets below this line do not need any changes.
// They are included here so you have the complete, final file.

class _FinalReportSection extends StatelessWidget {
  const _FinalReportSection();

  @override
  Widget build(BuildContext context) {
    // We can find the controller here when we need it.
    final GameStateController gameState = Get.find();
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.green[900]?.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "FILE FINAL REPORT:",
              style: Get.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
              child: const Text("REPORT A: Thorne is a Traitor"),
              onPressed: () => gameState.submitFinalReport(isTraitor: true),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
              child: const Text("REPORT B: Thorne is a Whistleblower"),
              onPressed: () => gameState.submitFinalReport(isTraitor: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseClosedBanner extends StatelessWidget {
  const _CaseClosedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[900],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          "CASE CLOSED",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _LogEntryCard extends StatelessWidget {
  final LogEntry entry;
  const _LogEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final GameStateController gameState = Get.find();

    return Card(
      color: const Color(0xFF1F1F1F),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.green.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '// LOG ENTRY [${entry.timestamp}] //',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (gameState.animatedLogEntryIds.contains(entry.id)) {
                return Text(
                  entry.text,
                  style: const TextStyle(color: Colors.white, height: 1.5),
                );
              } else {
                return AnimatedTextKit(
                  isRepeatingAnimation: false,
                  onFinished: () {
                    gameState.markLogEntryAsAnimated(entry.id);
                  },
                  animatedTexts: [
                    TypewriterAnimatedText(
                      entry.text,
                      speed: const Duration(milliseconds: 30),
                      textStyle: const TextStyle(color: Colors.white, height: 1.5),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}