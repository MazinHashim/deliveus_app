import 'package:deleveus_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AppPageWidget extends StatelessWidget {
  const AppPageWidget({
    required this.child,
    required this.title,
    this.space = 50,
    super.key,
  });
  final Widget child;
  final String title;
  final double space;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  ClipPath(
                    clipper: ContentClipper(),
                    child: Container(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    bottom: 0,
                    left: 15,
                    right: 0,
                    child: ClipPath(
                      clipper: ContentClipper(),
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(top: space),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
