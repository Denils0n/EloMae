import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elomae/app/models/onboard_model.dart';
import 'package:elomae/app/view_models/onboarding_viewmodel.dart';
import 'package:elomae/app/views/widgets/dot_indicator.dart';
import 'package:elomae/app/views/widgets/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: demo_data.length,
                      controller: viewModel.pageController,
                      onPageChanged: viewModel.setPage,
                      itemBuilder: (context, index) => OnboardContent(
                        image: demo_data[index].image,
                        title: demo_data[index].title,
                        description: demo_data[index].description,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        demo_data.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: DotIndicator(
                            isActive: index == viewModel.pageIndex,
                          ),
                        ),
                      ),
                      const Spacer(),
                      viewModel.pageIndex == demo_data.length - 1
                          ? SizedBox(
                              width: 170,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: viewModel.nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8566E0),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Comece Agora',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500), 
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: viewModel.nextPage,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: const Color(0xFF8566E0),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
