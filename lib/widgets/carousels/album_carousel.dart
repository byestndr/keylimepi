import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/spotify/album_provider.dart';

class AlbumCarousel extends ConsumerStatefulWidget {
  const AlbumCarousel({super.key});

  @override
  ConsumerState<AlbumCarousel> createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends ConsumerState<AlbumCarousel> {
  
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> albumList = ref.watch(
      albumProviderProvider,
    );

    return CarouselView(
      onTap: (int index) async {
        await ref.read(albumProviderProvider.notifier).startAlbum(index);
      },
      itemExtent: 200,
      children: List<Widget>.generate(
        albumList.when(
          data: (List data) => data.length,
          error: (Object error, StackTrace stack) => 1,
          loading: () => 1,
        ),
        (int index) => albumList.when(
          data: (List data) {
            return Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsGeometry.directional(
                    top: 135,
                    start: 15,
                  ),
                  child: Text(
                    data[index]['album']['name'],
                    style: const TextStyle(
                      fontFamily: 'Roboto Flex',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.directional(
                    top: 162,
                    start: 15,
                  ),
                  child: Text(
                    data[index]['album']['artists'][0]['name'],
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Roboto Flex',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: <Color>[Colors.black12, Colors.black],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: Image.network(
                      data[index]['album']['images'][0]['url'],
                    ),
                  ),
                ),
              ],
            );
          },
          error: (Object error, StackTrace stack) {
            return const Center(child: CircularProgressIndicator());
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
