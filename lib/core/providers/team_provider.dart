// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/team_provider.dart
// Team tree data, view mode, filters, search and sort (SECTION 8).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import '../firebase/firestore_service.dart';
import '../models/team_member_model.dart';

enum TeamViewMode { tree, list }
enum TeamSort { earnings, joinDate, name, teamSize, rank }

class TeamProvider extends ChangeNotifier {
  List<TeamMemberModel> _members = const [];
  TeamMemberModel? _rootNode;
  bool _loading = false;
  Object? _error;
  TeamViewMode _viewMode = TeamViewMode.tree;
  int _levelFilter = 0; // 0 = all
  String _search = '';
  TeamSort _sort = TeamSort.joinDate;

  List<TeamMemberModel> get members => _members;
  TeamMemberModel? get rootNode => _rootNode;
  bool get loading => _loading;
  Object? get error => _error;
  TeamViewMode get viewMode => _viewMode;
  int get levelFilter => _levelFilter;
  String get search => _search;
  TeamSort get sort => _sort;

  final FirestoreService _firestore = FirestoreService.instance;

  /// Loads the current user's team node and their level-1 children.
  Future<void> loadTeamTree(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final root = await _firestore.getTeamNode(userId);
      _rootNode = root;
      // root.children are level-1 user ids
      final level1 = await _firestore.getTeamNodes(root?.children ?? const []);
      _members = level1
          .map((m) => m.copyWith(level: 1, children: m.children))
          .toList();
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Fetches children of a given node id (lazy expansion).
  Future<List<TeamMemberModel>> fetchChildren(
      String userId, int childLevel) async {
    final node = await _firestore.getTeamNode(userId);
    if (node == null) return const [];
    final children =
        await _firestore.getTeamNodes(node.children);
    return children
        .map((m) => m.copyWith(level: childLevel, children: m.children))
        .toList();
  }

  void setViewMode(TeamViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setLevelFilter(int level) {
    _levelFilter = level;
    notifyListeners();
  }

  void setSearch(String q) {
    _search = q;
    notifyListeners();
  }

  void setSort(TeamSort sort) {
    _sort = sort;
    notifyListeners();
  }

  /// Filtered + sorted list for the list view.
  List<TeamMemberModel> get filteredMembers {
    var list = [..._members];
    if (_levelFilter > 0) {
      list = list.where((m) => m.level == _levelFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list
          .where((m) =>
              m.fullName.toLowerCase().contains(q) ||
              m.memberId.toLowerCase().contains(q))
          .toList();
    }
    switch (_sort) {
      case TeamSort.earnings:
        list.sort((a, b) => b.monthlyEarnings.compareTo(a.monthlyEarnings));
        break;
      case TeamSort.name:
        list.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case TeamSort.teamSize:
        list.sort((a, b) => b.totalDownline.compareTo(a.totalDownline));
        break;
      case TeamSort.rank:
        list.sort((a, b) => b.rankLevel.compareTo(a.rankLevel));
        break;
      case TeamSort.joinDate:
        list.sort((a, b) =>
            (b.joiningDate ?? DateTime.now())
                .compareTo(a.joiningDate ?? DateTime.now()));
        break;
    }
    return list;
  }

  /// Top-level stats for the stats header.
  Map<String, int> get stats {
    final total = _members.length;
    final active = _members.where((m) => m.isActive).length;
    final direct = _members.where((m) => m.level == 1).length;
    final newThisMonth = _members
        .where((m) =>
            m.joiningDate != null &&
            m.joiningDate!.month == DateTime.now().month &&
            m.joiningDate!.year == DateTime.now().year)
        .length;
    return {
      'total': total,
      'active': active,
      'direct': direct,
      'new': newThisMonth,
    };
  }
}
