import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';

//Programado por HeroRickyGames
//Tecnologia feita pela Google e a equipe do VLC

class MYIpcamera extends StatelessWidget {
  const MYIpcamera({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalable OCR IPCAMERA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ipCamera(title: 'Flutter Scalable OCR com IPCAMERA'),
    );
  }
}

class ipCamera extends StatefulWidget {
  ipCamera({super.key, required this.title});

  final String title;

  final textRecognizer = GoogleMlKit.vision.textDetector();

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
    String stream = '/cgi-bin/faststream.jpg?stream=half&fps=15&rand=COUNTER';
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'http://84.232.147.36:8080$stream',
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

                final textRecognizer = GoogleMlKit.vision.textDetector();
                print('Pegando imagem e pondo no texto');


                final dir = (await getTemporaryDirectory()).path;
                final imageFile = File('$dir/b.png')..writeAsBytesSync(videoFrame);
                final image = InputImage.fromFile(imageFile);
                final result = await textRecognizer.processImage(image);
                String extractedText = result.text;
                print('Texto Extraido: $extractedText');
                print('Fim');

              }, child: const Text(
                  'Visualizar no console o texto extraido'
              )
              )
            ],
          ),
        ));
  }
}