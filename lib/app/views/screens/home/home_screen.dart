import 'package:flutter/material.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
        ),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 0),
    );
  }
}