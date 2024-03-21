import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voronoi/textfield.dart';
import 'package:voronoi/researches.dart';
import 'package:image/image.dart' as img;

Future<Uint8List> createDiagram(List<dynamic> params) async {
  // await to see the loading in the screen
  await Future.delayed(const Duration(milliseconds: 500));

  int width = params[0];
  int height = params[1];
  int basedStation = params[2];
  if (width == 0 || height == 0 || basedStation == 0) {
    throw Exception('All parameters are required');
  }
  // Creating new image
  img.Image diagram = img.Image(width: width, height: height);
  print('image created');
  List<DrawPixels> baseStationList =
      generatePixels(basedStation, width, height);
  for (var pixel in baseStationList) {
    pixel.color = generateRandomColor();
  }
  // Drawing the diagram
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      double minDistance = double.infinity;
      int minIndex = -1;
      for (int k = 0; k < basedStation; k++) {
        double distance =
            calculateDistance(i, j, baseStationList[k].x, baseStationList[k].y);
        if (distance < minDistance) {
          minDistance = distance;
          minIndex = k;
        }
      }
      img.drawPixel(diagram, i, j, baseStationList[minIndex].color);
    }
  }
  for (var pixel in baseStationList) {
    img.fillCircle(diagram,
        x: pixel.x,
        y: pixel.y,
        radius: 3,
        color: img.ColorFloat16.rgb(255, 255, 255));
  }
  return img.encodePng(diagram);
}

class VoronoiPageAsync extends StatefulWidget {
  const VoronoiPageAsync({super.key});

  @override
  State<VoronoiPageAsync> createState() => _VoronoiPageAsyncState();
}

class _VoronoiPageAsyncState extends State<VoronoiPageAsync> {
  final TextEditingController textEditingControllerWidth =
      TextEditingController();
  final TextEditingController textEditingControllerHeight =
      TextEditingController();
  final TextEditingController textEditingControllerStations =
      TextEditingController();
  Future<Uint8List>? diagramImage;
  int width = 0;
  int height = 0;
  int basedStation = 0;

  Future<void> drawDiagram() async {
    diagramImage = createDiagram([width, height, basedStation]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Voronoi Diagram'),
      ),
      body: SizedBox(
        height: 800,
        width: 600,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: diagramImage,
                  builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('connection state waiting');
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData == false) {
                      return const Icon(
                        Icons.image,
                        size: 40,
                      );
                    }

                    print('begin');
                    return Image.memory(snapshot.data!);
                  },
                ),
              ),
              MyTextField(
                hintText: 'Enter width',
                textEditingController: textEditingControllerWidth,
              ),
              MyTextField(
                hintText: 'Enter heigth',
                textEditingController: textEditingControllerHeight,
              ),
              MyTextField(
                hintText: 'Enter amount of stations',
                textEditingController: textEditingControllerStations,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    width = int.tryParse(textEditingControllerWidth.text) ?? 0;
                    height =
                        int.tryParse(textEditingControllerHeight.text) ?? 0;
                    basedStation =
                        int.tryParse(textEditingControllerStations.text) ?? 0;
                  });
                  drawDiagram();
                },
                child: const Text('Create diagram'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
