import 'package:affinnes/screens/affine_transformations_screen.dart';
import 'package:affinnes/screens/fill/fill_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AffineTransformationsScreen(),
                  ),
                );
              },
              child: const Text('Аффинные преобразования'),
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FillScreen(),
                  ),
                );
              },
              child: const Text('Заливка'),
            ),
          ],
        ),
      ),
    );
  }
}
