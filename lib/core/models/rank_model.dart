// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/rank_model.dart
// Rank definition model (derived from MLMConfig.ranks).
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RankModel extends Equatable {
  final String name;
  final int level;
  final String colorHex;
  final String icon;
  final int minTeamSize;
  final int maxTeamSize;
  final double minCareerEarnings;
  final double rankBonus;

  const RankModel({
    required this.name,
    required this.level,
    required this.colorHex,
    required this.icon,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.minCareerEarnings,
    required this.rankBonus,
  });

  factory RankModel.fromMap(Map<String, dynamic> map) {
    return RankModel(
      name: map['name'] as String,
      level: map['level'] as int,
      colorHex: map['colorHex'] as String,
      icon: map['icon'] as String,
      minTeamSize: map['minTeamSize'] as int,
      maxTeamSize: map['maxTeamSize'] as int,
      minCareerEarnings: (map['minCareerEarnings'] as num).toDouble(),
      rankBonus: (map['rankBonus'] as num).toDouble(),
    );
  }

  Color get color => _colorFromHex(colorHex);

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  List<Object?> get props =>
      [name, level, colorHex, minTeamSize, minCareerEarnings];
}
