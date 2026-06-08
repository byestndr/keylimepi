import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewItem extends ConsumerWidget {
  final String id;
  final String name;
  final String? artist;
  const ViewItem({
    super.key,
    required this.id,
    required this.name,
    this.artist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: Stack(
              fit: .passthrough,
              children: [
                Image.asset('assets/imagePlaceholder.png', fit: .cover),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                Align(
                  alignment: .bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: .end,
                      children: [
                        SizedBox.square(
                          dimension: MediaQuery.of(context).size.height / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(12),
                            child: Image.asset('assets/imagePlaceholder.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisAlignment: .end,
                            children: [
                              Text(name),
                              artist != null
                                  ? Text("$artist")
                                  : const Padding(padding: .zero),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            expandedHeight: MediaQuery.of(context).size.height / 1.5,
          ),
        ],
      ),
    );
  }
}
