import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/constants/AppKeys.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';

import '../domain/entities/user_entity.dart';
import '../domain/usecases/login_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthViewModel({required this.loginUseCase});

  UserEntity? _user;
  UserEntity? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await loginUseCase(email, password);

      // Persist login state
      await PrefsHelper.setBool(AppKeys.isLoggedIn, true);
      await PrefsHelper.setString(AppKeys.userId, _user!.uid);
      await PrefsHelper.setString(AppKeys.userEmail, _user!.email);
      if (_user!.name != null) {
        await PrefsHelper.setString(AppKeys.userFullName, _user!.name!);
      }
      if (_user!.role != null) {
        await PrefsHelper.setString(AppKeys.userRole, _user!.role!);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    await PrefsHelper.remove(AppKeys.isLoggedIn);
    await PrefsHelper.remove(AppKeys.userId);
    await PrefsHelper.remove(AppKeys.userEmail);
    await PrefsHelper.remove(AppKeys.userFullName);
    await PrefsHelper.remove(AppKeys.userRole);
    notifyListeners();
  }
}
