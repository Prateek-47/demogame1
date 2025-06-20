// lib/features/browser/browser_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'browser_controller.dart';

class BrowserScreen extends GetView<BrowserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secure Browser")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Obx makes this widget reactive to changes in the controller
        child: Obx(() {
          switch (controller.currentPage.value) {
            case BrowserPage.searchHome:
              return _buildSearchPage();
            case BrowserPage.searchResults:
              return _buildResultsPage();
            case BrowserPage.bankLogin:
              return _buildLoginPage();
            case BrowserPage.bankTransactions:
              return _buildTransactionsPage();
              case BrowserPage.mapView:
              return _buildMapView();
              
          }
        }),
      ),
    );
  }

Widget _buildMapView() {
    return Column(
      children: [
        Text("Rendezvous Point: Private Airfield", style: Get.textTheme.titleMedium),
        SizedBox(height: 10),
        // In a real app, this could be a map widget. For now, an image is perfect.
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              image: DecorationImage(
                // You can find and add a placeholder map image to your assets
                image: AssetImage('assets/images/placeholder_map.png'), 
                
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: Icon(Icons.location_pin, color: Colors.red, size: 50)),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSearchPage() {
    return Column(
      children: [
        TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'Search query...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (_) => controller.performSearch(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.performSearch,
          child: Text('Search'),
        ),
      ],
    );
  }

  Widget _buildResultsPage() {
    return ListView(
      children: [
        Text('Showing results for "gilded cage"'),
        Divider(),
        ListTile(
          leading: Icon(Icons.link),
          title: Text('Gilded Cage Financial - Secure Offshore Banking', style: TextStyle(color: Colors.blue[300])),
          subtitle: Text('The premier choice for discreet asset management.'),
          onTap: () => controller.navigateTo(BrowserPage.bankLogin),
        ),
      ],
    );
  }

  Widget _buildLoginPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Gilded Cage Financial', style: Get.textTheme.headlineSmall),
        SizedBox(height: 30),
        TextField(
          controller: controller.usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        SizedBox(height: 20),
        Text('// BIOMETRIC KEY REQUIRED //', style: TextStyle(color: Colors.red)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.attemptLogin,
          child: Text('Attempt Secure Login'),
        ),
      ],
    );
  }
}

Widget _buildTransactionsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account: athorne', style: Get.textTheme.titleLarge),
        Text('Status: ACCESS GRANTED', style: TextStyle(color: Colors.green)),
        Divider(height: 30),
        Text('TRANSACTION HISTORY:', style: Get.textTheme.titleMedium),
        SizedBox(height: 10),
        Card(
          color: Color(0xFF2A2A2A),
          child: ListTile(
            leading: Icon(Icons.receipt_long, color: Colors.orangeAccent),
            title: Text('Outgoing Transfer - Anonymous Wallet'),
            subtitle: Text('Amount: [REDACTED]'),
            trailing: Icon(Icons.attachment),
          ),
        ),
        SizedBox(height: 20),
        Text(
          '// ANALYSIS: A single large transfer was made recently. The transaction contains one encrypted attachment File has been automatically downloaded to your File Vault. //8.2.6',
          style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        )
      ],
    );
  }