import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/lyrics/providers/lyrics_provider.dart';

class DelayInfo extends ConsumerStatefulWidget {
  const DelayInfo({super.key});

  @override
  ConsumerState<DelayInfo> createState() => _DelayInfoState();
}

class _DelayInfoState extends ConsumerState<DelayInfo> {
  @override
  Widget build(BuildContext context) {
    final int delay = ref.watch(lyricDelayProvider);

    return Material(
      type: .button,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: .antiAlias,
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: delay == 0 ? 0 : 6,
      child: InkWell(
        onTap: () {
          ref.read(lyricDelayProvider.notifier).resetDelay();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
          width: delay == 0 ? 0 : 100,
          height: delay == 0 ? 0 : 40,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$delay ms',
              style: TextStyle(
                color: delay == 0
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DelayControls extends ConsumerWidget {
  const DelayControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 5,
      crossAxisAlignment: .end,
      mainAxisAlignment: .end,
      children: <Widget>[
        const DelayInfo(),
        Column(
          mainAxisAlignment: .end,
          spacing: 5,
          crossAxisAlignment: .end,
          children: <Widget>[
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                ref.read(lyricDelayProvider.notifier).increaseDelay(100);
              },
              tooltip: 'Increase delay',
              child: const Icon(Icons.arrow_upward_rounded),
            ),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                ref.read(lyricDelayProvider.notifier).decreaseDelay(100);
              },
              tooltip: 'Decrease delay',
              child: const Icon(Icons.arrow_downward_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
