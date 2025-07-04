import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    required this.image,
    required this.title,
    required this.description,
    super.key,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(width: 100, height: 350, image),
        const Spacer(),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}