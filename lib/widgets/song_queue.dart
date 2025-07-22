import 'package:flutter/material.dart';

class QueueSideSheet extends StatefulWidget {
  const QueueSideSheet({super.key});

  @override
  State<QueueSideSheet> createState() => _QueueSideSheetState();
}

class _QueueSideSheetState extends State<QueueSideSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      width: MediaQuery.of(context).devicePixelRatio * 300,
      child: const Padding(
        padding: EdgeInsetsGeometry.directional(
          top: 8,
          bottom: 5,
          end: 6,
        ),
        child: QueueContent(),
      ),
    );
  }
}

class QueueContent extends StatefulWidget {
  const QueueContent({super.key});

  @override
  State<QueueContent> createState() => _QueueContentState();
}

class _QueueContentState extends State<QueueContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(children: [Text('Queue'), ]),
    );
  }
}
