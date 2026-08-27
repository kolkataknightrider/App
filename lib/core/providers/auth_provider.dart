// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/auth_provider.dart
// Authentication state management (SECTION 6).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import '../firebase/auth_service.dart';
import '../firebase/firestore_service.dart';
import '../models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  bool _isLockedOut = false;
  int _lockoutMinutes = 0;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLockedOut => _isLockedOut;
  int get lockoutMinutes => _lockoutMinutes;

  final AuthService _auth = AuthService.instance;
  final FirestoreService _firestore = FirestoreService.instance;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLockedOut = await _auth.isLockedOut();
    if (_isLockedOut) _lockoutMinutes = await _auth.lockoutMinutesRemaining();
    _status = _auth.currentUid != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();

    // If already signed in, load the user document.
    if (_auth.currentUid != null) {
      try {
        _user = await _firestore.getUser(_auth.currentUid!);
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    }
  }

  /// Validates account status from the loaded user document.
  String? _validateAccount(UserModel user) {
    if (!user.isActive) return 'Your account has been deactivated.';
    if (!user.joiningFeePaid) return 'Joining fee not paid.';
    return null;
  }

  Future<void> login({
    required String memberId,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.signIn(
        memberId: memberId, password: password,
      );
      final user = await _firestore.getUser(credential.user!.uid);
      final validationError = _validateAccount(user);
      if (validationError != null) {
        await _auth.signOut();
        _status = AuthStatus.error;
        _error = validationError;
        notifyListeners();
        return;
      }
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
    } on AuthException catch (e) {
      _isLockedOut = await _auth.isLockedOut();
      if (_isLockedOut) {
        _lockoutMinutes = await _auth.lockoutMinutesRemaining();
      }
      _status = AuthStatus.error;
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loginWithBiometrics() async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final credential = await _auth.signInWithBiometrics();
      final user = await _firestore.getUser(credential.user!.uid);
      final validationError = _validateAccount(user);
      if (validationError != null) {
        await _auth.signOut();
        _status = AuthStatus.error;
        _error = validationError;
        notifyListeners();
        return;
      }
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    if (_status == AuthStatus.error) _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
