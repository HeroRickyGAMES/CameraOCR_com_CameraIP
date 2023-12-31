import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

//Programado por HeroRickyGames
//Tecnologia feita pela Google e a equipe do VLC
final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
String extractedText = '';

class MYIpcamera extends StatelessWidget {
  const MYIpcamera({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalable OCR IPCAMERA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: ipCamera(title: 'Flutter Scalable OCR com IPCAMERA'),
    );
  }
}

class ipCamera extends StatefulWidget {
  ipCamera({super.key, required this.title});

  final String title;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  State<ipCamera> createState() => _ipCameraState();
}
String textocomEstado = '';
class _ipCameraState extends State<ipCamera> {
  String text = "";
  String tratado = '';
  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {
    print('Inicializado!');
  }

  disposer() async {
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.3.45:80/0',
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              VlcPlayer(controller:
              _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator()
                ),
              ),
              ElevatedButton(onPressed: () async {
                await _videoPlayerController.stopRendererScanning();
                await _videoPlayerController.dispose();
                Navigator.of(context).pop();
              }, child: const Text('Close IP CAMERA'),
              ),
              ElevatedButton(onPressed: () async {
                await _videoPlayerController.stopRendererScanning();
                await _videoPlayerController.dispose();

              }, child: const Text('Dispose IP CAMERA'),
              ),
              ElevatedButton(onPressed: () async {

                Uint8List videoFrame = await _videoPlayerController.takeSnapshot();

                print('Pegando imagem e pondo no texto');


                final dir = (await getTemporaryDirectory()).path;
                final imageFile = File('$dir/b.png')..writeAsBytesSync(videoFrame);
                final image = InputImage.fromFile(imageFile);


                final result = await textRecognizer.processImage(image);
                setState(() {
                  extractedText = result.text;
                });

                print('Texto Extraido: $extractedText');
                print('Fim');

              }, child: const Text(
                  'Visualizar no console o texto extraido'
              )
              ),
              Text('Texto extraido: $extractedText')
            ],
          ),
        ));
  }
}