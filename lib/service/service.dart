import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import '../multimedia/page_manager.dart';
import 'audio_andler.dart';
//import 'playlist_ripository.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
 // getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());

  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}