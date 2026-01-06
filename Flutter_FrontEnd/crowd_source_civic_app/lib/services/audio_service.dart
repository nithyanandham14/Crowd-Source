import 'package:record/record.dart';

final record = AudioRecorder();

Future<void> recordAudio() async {
  if (await record.hasPermission()) {
    await record.start(const RecordConfig(), path: 'audio.m4a');
    // print("Recording started");

    await Future.delayed(const Duration(seconds: 5));
    await record.stop();
    // print("Audio saved at: $path");
  }
}
