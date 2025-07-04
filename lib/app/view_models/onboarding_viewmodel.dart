import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController _pageController = PageController(initialPage: 0);

  PageController get pageController => _pageController;

  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void setPage(int index){
    _pageIndex = index;
    notifyListeners();
  }

  void nextPage(){
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}