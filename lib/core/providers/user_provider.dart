// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/user_provider.dart
// Current user data + real-time updates.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:partix/core/firebase/firestore_service.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/models/bank_details_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _loading = false;
  Object? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  Object? get error => _error;

  final FirestoreService _firestore = FirestoreService.instance;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Subscribes to real-time updates for [userId].
  void watchUser(String userId) {
    _loading = _user == null;
    notifyListeners();
    _firestore.streamUser(userId).listen((user) {
      _user = user;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _loading = false;
      _error = e;
      notifyListeners();
    });
  }

  Future<void> refresh(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await _firestore.getUser(userId);
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? address,
  }) async {
    if (_user == null) return;
    await _firestore.updateUser(_user!.uid, {
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    });
    _user = _user!.copyWith(
      fullName: fullName,
      phone: phone,
      address: address,
    );
    notifyListeners();
  }

  Future<void> updateBank(BankDetailsModel bank) async {
    if (_user == null) return;
    await _firestore.updateBankDetails(_user!.uid, bank);
    _user = _user!.copyWith(bankDetails: bank);
    notifyListeners();
  }

  Future<void> updatePreferences({
    String? language,
    String? theme,
    bool? biometricEnabled,
    bool? notificationsEnabled,
  }) async {
    if (_user == null) return;
    await _firestore.updatePreferences(
      _user!.uid,
      language: language,
      theme: theme,
      biometricEnabled: biometricEnabled,
      notificationsEnabled: notificationsEnabled,
    );
    _user = _user!.copyWith(
      language: language,
      theme: theme,
      biometricEnabled: biometricEnabled,
      notificationsEnabled: notificationsEnabled,
    );
    notifyListeners();
  }
}
