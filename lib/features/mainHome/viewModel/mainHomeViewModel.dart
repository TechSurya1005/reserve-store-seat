import 'package:flutter/cupertino.dart';

class MainHomeViewModel extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);
  int _navIndex = 0;

  int get navIndex => _navIndex;

  void setNavIndex(int index) {
    if (index == _navIndex) return;
    _navIndex = index;
    notifyListeners();
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Handle page changes from swipe gestures
  void onPageChanged(int index) {
    if (index == _navIndex) return;
    _navIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
