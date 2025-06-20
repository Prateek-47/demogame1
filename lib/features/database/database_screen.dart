// lib/features/database/database_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'database_controller.dart';

class DatabaseScreen extends GetView<DatabaseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agency Database'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            // This is the reactive part of our screen
            Expanded(
              child: Obx(() {
                switch (controller.searchStatus.value) {
                  case SearchStatus.initial:
                    return _buildInitialState();
                  case SearchStatus.loading: // <-- ADD THIS NEW CASE
                    return _buildLoadingState();
                  case SearchStatus.notFound:
                    return _buildNotFoundState();
                  case SearchStatus.found:
                    return _buildDossierResult();
                  default:
                    return _buildInitialState();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter search query...',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            onSubmitted: (_) => controller.performSearch(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: controller.performSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            minimumSize: const Size(60, 60),
          ),
          child: const Icon(Icons.search),
        )
      ],
    );
  }

  Widget _buildInitialState() {
    return const Center(child: Text('// AWAITING QUERY //'));
  }
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 20),
          Text('// QUERYING AGENCY DATABASE... //'),
        ],
      ),
    );
  }


  Widget _buildNotFoundState() {
    return const Center(child: Text('// NO MATCHING RECORDS FOUND //'));
  }

  Widget _buildDossierResult() {
    return SingleChildScrollView(
      child: Card(
        color: const Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.green.withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '// RECORD FOUND: 1',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.green, thickness: 0.5, height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/dossier_petrova.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NAME: Petrova, Lena', style: Get.theme.textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text('ID: 73-9B1-LP', style: Get.theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text('AFFILIATION: OmniCorp', style: Get.theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text('ROLE: Junior Bio-Data Researcher', style: Get.theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.green, thickness: 0.5, height: 20),
              Text('ANALYSIS:', style: TextStyle(color: Colors.green[700])),
              const SizedBox(height: 8),
              Text(
                'Subject is a key associate of Dr. Aris Thorne. Low security profile. Holds access to secure internal communication channels.',
                style: Get.theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 16),
              Text('SECURE CONTACT ID: LPetrova_84', style: Get.theme.textTheme.bodyLarge?.copyWith(backgroundColor: Colors.green, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}