import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'models/member.dart';

final memberNumProvider = StateProvider<int>((ref) => 0);
final memberIndexProvider = StateProvider<int>((ref) => 1);
final cameraProvider = FutureProvider<CameraDescription>((ref) async {
  final cameras = await availableCameras();
  return cameras[1];
});
final membersProvider = StateProvider<List<Member>>((ref) => []);
