// lib/app/controllers/game_state_controller.dart

import 'package:get/get.dart';
import '../data/models/file_model.dart';
import '../data/models/log_entry_model.dart';
import '../data/models/dialogue_model.dart';
import '../../app/services/sound_service.dart';

class GameStateController extends GetxController {
  // --- STATE VARIABLES ---
  final allGameFiles = <GameFile>[].obs;
  final unlockedClueIds = <String>{}.obs;
  final logEntries = <LogEntry>[].obs;
  final conversations = <String, Conversation>{}.obs;
  final viewedEvidenceIds = <String>{}.obs;
  final isCaseClosed = false.obs;
  // --- NEW: A reactive set to store the IDs of animated entries ---
  final animatedLogEntryIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    // CORRECTED: Removed duplicate file definitions. Each file is now listed only once.
    allGameFiles.assignAll([
      GameFile(id: 'dossier_petrova', fileName: 'dossier_lena_petrova.doss', type: FileType.dossier, isLocked: false),
      GameFile(id: 'firewall_bypass', fileName: 'FIREWALL_BYPASS.exe', type: FileType.executable, isLocked: true),
      GameFile(id: 'note_for_lb', fileName: 'NOTE_FOR_LB.aax', type: FileType.audio, isLocked: true, password: 'littlebird'),
      GameFile(id: 'rendezvous_geo', fileName: 'rendezvous_point.geo', type: FileType.geolink, isLocked: true),
      GameFile(
        id: 'manifest_pdf',
        fileName: 'manifest.pdf',
        type: FileType.pdf,
        isLocked: true,
        // The content is now correctly part of the one and only definition.
        content: "FLIGHT MANIFEST: NVG-722\nCARGO: Nightingale Project - Live Bio-Asset\nPASSENGER: A. Thorne (Alias: Mr. Byrd)\nDESTINATION: [REDACTED]"
      ),
    ]);

    // Add the first log entry for our story
    addLogEntry(
        '22:04',
        "CASE FILE: NIGHTINGALE\nAgent, we have a situation. Dr. Aris Thorne, OmniCorp's lead scientist on their 'Nightingale' bio-integration project, has gone dark. Security footage from his lab is corrupted, but the last image shows a cryptic symbol scrawled on a whiteboard.\n\nOBJECTIVE: Your first step is to identify and locate his junior researcher, Lena Petrova. Start with the database.",
      );

    _loadConversations();
  }
  
  void _loadConversations() {
    conversations['LPetrova_84'] = Conversation(
      contactId: 'LPetrova_84',
      contactName: 'Lena Petrova',
      startNodeId: 'start',
      nodes: {
        'start': DialogueNode(
          id: 'start',
          speaker: Speaker.lena,
          text: "Who is this? How did you get this number?",
          choices: [
            DialogueChoice(text: "I know about Nightingale. Talk to me now.", nextNodeId: 'aggro_2'),
            DialogueChoice(text: "I'm not with OmniCorp. I think you're in trouble.", nextNodeId: 'empathy_2'),
          ],
        ),
        'aggro_2': DialogueNode(
          id: 'aggro_2',
          speaker: Speaker.lena,
          text: "I don't know what you're talking about. Stay away from me!",
        ),
        'empathy_2': DialogueNode(
          id: 'empathy_2',
          speaker: Speaker.lena,
          text: "Trouble...? I... I can't talk. They're watching everything.",
          choices: [
            DialogueChoice(text: "Who is watching? I can help.", nextNodeId: 'empathy_4')
          ],
        ),
        'empathy_4': DialogueNode(
          id: 'empathy_4',
          speaker: Speaker.lena,
          text: "You can't. Nobody can. It wasn't a lab. It was a cage... a gilded cage. He called me his little bird. Now they're watching me. Don't contact me again.",
          triggerClue: 'gilded_cage_clue',
        ),
      },
    );
  }

  // --- PUBLIC METHODS ---

   // --- MODIFIED: The addLogEntry method now creates a unique ID ---
  void addLogEntry(String timestamp, String text) {
    // We create a unique ID using the current time.
    final entryId = 'log_${DateTime.now().millisecondsSinceEpoch}';
    logEntries.insert(0, LogEntry(id: entryId, timestamp: timestamp, text: text));
    Get.find<SoundService>().playNotification();
  }

  // --- NEW: A method to mark an entry as having been animated ---
  void markLogEntryAsAnimated(String entryId) {
    animatedLogEntryIds.add(entryId);
  }

  GameFile? getFileById(String id) {
    return allGameFiles.firstWhereOrNull((file) => file.id == id);
  }

  void unlockFile(String id) {
    final file = getFileById(id);
    if (file != null) {
      file.isLocked = false;
      allGameFiles.refresh();
      print('Unlocked file: ${file.fileName}');
    }
  }

  void addClue(String clueId) {
    unlockedClueIds.add(clueId);
    print('Added clue: $clueId');
  }

  void markEvidenceAsViewed(String evidenceId) {
    viewedEvidenceIds.add(evidenceId);
    if (viewedEvidenceIds.contains('rendezvous_geo') && viewedEvidenceIds.contains('manifest_pdf')) {
      if (!unlockedClueIds.contains('final_choice_unlocked')) {
        addClue('final_choice_unlocked');
        addLogEntry(
          '00:15',
          'All evidence has been reviewed. The picture is clear. Dr. Thorne initiated his own extraction to prevent OmniCorp from weaponizing his research.\n\nOBJECTIVE: File your final report. Your assessment will determine the agency\'s response.',
        );
      }
    }
  }

  void submitFinalReport({required bool isTraitor}) {
    if (isCaseClosed.value) return;

    String epilogue;
    if (isTraitor) {
      epilogue = "EPILOGUE: You reported Thorne as a traitor. An agency team was dispatched to intercept him at the airfield. The 'Nightingale' asset was recovered and is now under secure evaluation by OmniCorp. Lena Petrova has been taken into protective custody. Your handling of the case has been noted by Control.";
    } else {
      epilogue = "EPILOGUE: You reported Thorne as a whistleblower. The agency has allowed him to disappear, placing a surveillance tag on him instead. An internal investigation into OmniCorp's weaponization program has been opened, citing your report. Lena Petrova has been quietly extracted and given a new identity. Your discretion has been noted by Control.";
    }

    addLogEntry('01:30', epilogue);
    isCaseClosed.value = true;
  }
}