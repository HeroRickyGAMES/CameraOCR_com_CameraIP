import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:testedeextracttexteipcamera/ipcamera.dart';

//Programado por HeroRickyGames
//Tecnologia feita pela Google e a equipe do qedcode.io

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalable OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Scalable OCR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
String textocomEstado = '';
class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  String tratado = '';

  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
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
              Text('Recomendamos que mantenha centralizado na placa antes de tirar a foto!'),
              ScalableOCR(
                  paintboxCustom: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.0
                    ..color = const Color.fromARGB(153, 102, 160, 241),
                  boxLeftOff: 5,
                  boxBottomOff: 2.5,
                  boxRightOff: 5,
                  boxTopOff: 2.5,
                  boxHeight: MediaQuery.of(context).size.height / 3,
                  getRawData: (value) {
                    inspect(value);
                  },
                  getScannedText: (value) {
                    setText(value);
                  }
              ),
              StreamBuilder<String>(
                stream: controller.stream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Center(
                      child: Column(
                        children: [
                          Result(text: snapshot.data != null ? snapshot.data! : ""),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              String x = '';
                              textocomEstado = snapshot.data!;
                              //print(textocomEstado);

                              List<String> partes = textocomEstado.split(' ');

                              String nomePlaca = partes.join('');

                              x = nomePlaca.toUpperCase()
                                  .replaceAll("BRASIL", '')
                                  .replaceAll("BR", '')
                                  .replaceAll("ACRE", '')
                                  .replaceAll("ALAGOAS", '')
                                  .replaceAll("ALAGOAS", '')
                                  .replaceAll("AMAPÁ", '')
                                  .replaceAll("AMAZONAS", '')
                                  .replaceAll("AMAZONAS", '')
                                  .replaceAll("BAHIA", '')
                                  .replaceAll("CEARÁ", '')
                                  .replaceAll("DISTRITO FEDERAL", '')
                                  .replaceAll("ESPÍRITO SANTO", '')
                                  .replaceAll("GOIÁS", '')
                                  .replaceAll("MARANHÃO", '')
                                  .replaceAll("MATO GROSSO", '')
                                  .replaceAll("MATO GROSSO DO SUL", '')
                                  .replaceAll("MINAS GERAIS", '')
                                  .replaceAll("PARÁ", '')
                                  .replaceAll("PARAÍBA", '')
                                  .replaceAll("PARANÁ", '')
                                  .replaceAll("PERNAMBUCO", '')
                                  .replaceAll("PIAUÍ", '')
                                  .replaceAll("RIO DE JANEIRO", '')
                                  .replaceAll("RIO GRANDE DO NORTE", '')
                                  .replaceAll("RIO GRANDE DO SUL", '')
                                  .replaceAll("RONDÔNIA", '')
                                  .replaceAll("RORAIMA", '')
                                  .replaceAll("SANTA CATARINA", '')
                                  .replaceAll("SÃO PAULO", '')
                                  .replaceAll("SERGIPE", '')
                                  .replaceAll("TOCANTINS", '')
                                  .replaceAll("AC", '')
                                  .replaceAll("AL", '')
                                  .replaceAll("AP", '')
                                  .replaceAll("AM", '')
                                  .replaceAll("BA", '')
                                  .replaceAll("CE", '')
                                  .replaceAll("DF", '')
                                  .replaceAll("ES", '')
                                  .replaceAll("GO", '')
                                  .replaceAll("MA", '')
                                  .replaceAll("MT", '')
                                  .replaceAll("MS", '')
                                  .replaceAll("MG", '')
                                  .replaceAll("PA", '')
                                  .replaceAll("PB", '')
                                  .replaceAll("PR", '')
                                  .replaceAll("PE", '')
                                  .replaceAll("PI", '')
                                  .replaceAll("RJ", '')
                                  .replaceAll("RN", '')
                                  .replaceAll("RS", '')
                                  .replaceAll("RO", '')
                                  .replaceAll("RR", '')
                                  .replaceAll("SC", '')
                                  .replaceAll("SP", '')
                                  .replaceAll("SE", '')
                                  .replaceAll("TO", '')
                                  .replaceAll("-", ' ')
                                  .replaceAllMapped(
                                RegExp(r'^([a-zA-Z]{3})([0-9a-zA-Z]{4})$'),
                                    (Match m) => '${m[1]} ${m[2]}',
                              );

                              tratado = x;

                              print("placas da camera $x");  // [XXX7XXX]
                            });

                          }, child: Text('Travar texto')
                          ),
                          Text("Estado extraido: $tratado"),
                          ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return ipCamera(title: 'Flutter Scalable OCR IPCAMERA',);
                                }));

                          }, child: Text('Mudar para IP CAMERA'))
                        ],
                      )
                  );
                },
              )
            ],
          ),
        ));
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}