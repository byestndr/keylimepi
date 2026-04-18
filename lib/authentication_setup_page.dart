import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/app_body.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';
import 'package:spotimmich/settings/spotify/spotifypage.dart';

class AuthenticationSetupPage extends ConsumerWidget {
  const AuthenticationSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isAuthenticated = ref.watch(spotifyAuthenticatedProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'RobotoFlexVariable',
                  fontVariations: [
                    FontVariation.width(80),
                    FontVariation.weight(600),
                    FontVariation('GRAD', 10),
                  ],
                ),
              ),
              const Text(
                'You are currently not logged in, press the button below to get started.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'RobotoFlexVariable',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: isAuthenticated
                    ? FilledButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const AppBody(),
                            ),
                          );
                        },
                        child: const Text('Continue'),
                      )
                    : FilledButton.tonal(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SpotifyPage(),
                          ),
                        ),
                        child: const Text('Log in to Spotify'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
