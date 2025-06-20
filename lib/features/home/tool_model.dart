// lib/features/home/tool_model.dart

import 'package:flutter/material.dart';

class Tool {
  final String name;
  final IconData icon;
  final String route; // The route to navigate to when tapped

  Tool({
    required this.name,
    required this.icon,
    required this.route,
  });
}