import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

final maleNumProvider = StateProvider<int>((ref) => 0);
final femaleNumProvider = StateProvider<int>((ref) => 0);
final cameraProvider = FutureProvider<CameraDescription>((ref) async {
  final cameras = await availableCameras();
  return cameras[1];
});
