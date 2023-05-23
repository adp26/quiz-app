import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:quiz_game/theme.dart';
import 'package:quiz_game/views/main_page.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../notifier/quiz_notifier.dart';

class ResultQuizPage extends StatefulWidget {
  ResultQuizPage({required this.getTopics});
  late final getTopics;
  @override
  State<ResultQuizPage> createState() => _ResultQuizPageState();
}

class _ResultQuizPageState extends State<ResultQuizPage> {
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey previewContainer = GlobalKey();
  var directory = "";
  var directoryComplete = "";
  Uint8List pngBytes = Uint8List(0);
  File imgFile = File("");
  List<String> objCardName = [];
  takeScreenShot() async {}

  int score(List jwb, List dataSoal) {
    int nilai = 0;
    for (var data in dataSoal) {
      // print(data);
      for (var userJwb in jwb) {
        if (userJwb == "") {
          break;
        }
        if (userJwb == data['answer']) {
          nilai++;
          break;
        }
      }
    }

    return nilai;
  }

  @override
  Widget build(BuildContext context) {
    Widget wrongAnswer(String jwb) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.close,
            color: Colors.red,
          ),
          Text(
            jwb,
            style: resultQuizTextStyle,
          )
        ],
      );
    }

    Widget correctAnswer(String jwb) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
          Text(
            jwb,
            style: resultQuizTextStyle,
          )
        ],
      );
    }

    List<Widget> correctionResult(List jwb, List dataSoal) {
      List<Widget> lstWidget = [];

      for (var iData = 0; iData < dataSoal.length; iData++) {
        lstWidget.add(Text(
          '${dataSoal[iData]['question']}?',
          style: const TextStyle(color: Colors.white),
        ));
        lstWidget.add(const SizedBox(
          height: 5,
        ));
        for (var iJwb = 0; iJwb < jwb.length; iJwb++) {
          if (iData == iJwb) {
            if (jwb[iJwb] == "") {
              lstWidget.add(Row(
                children: [
                  wrongAnswer('-'),
                  const SizedBox(
                    width: 20,
                  ),
                  correctAnswer(dataSoal[iData]['answer']),
                ],
              ));
              lstWidget.add(const SizedBox(
                height: 20,
              ));
            } else if (jwb[iJwb] == dataSoal[iData]['answer']) {
              lstWidget.add(Row(
                children: [
                  correctAnswer(jwb[iJwb]),
                ],
              ));
              lstWidget.add(const SizedBox(
                height: 20,
              ));
            } else {
              lstWidget.add(Row(
                children: [
                  wrongAnswer(jwb[iJwb]),
                  const SizedBox(
                    width: 20,
                  ),
                  correctAnswer(dataSoal[iData]['answer']),
                ],
              ));
              lstWidget.add(const SizedBox(
                height: 20,
              ));
            }
            break;
          }
        }
      }

      return lstWidget;
    }

    Widget buttonShare() {
      return TextButton(
        style: TextButton.styleFrom(
            minimumSize: Size(200, 40),
            backgroundColor: backgroundColor2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
        onPressed: () async {
          final image = await screenshotController.capture();

          if (image == null) return;
          saveAndShare(image);
        },
        child: Text(
          'Share your score',
          style: primaryTextStyle.copyWith(
            fontSize: 13,
          ),
        ),
      );
    }

    AppBar header() {
      return AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainPage()),
                (Route<dynamic> route) => false);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Your Score',
          style: titleTextStyle,
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
      );
    }

    Widget circleScore(int nilai, int jumlahSoal) {
      return CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: (nilai / jumlahSoal),
        center: Text(
          "$nilai/$jumlahSoal",
          style: const TextStyle(color: Colors.white),
        ),
        progressColor: circleColor1,
        backgroundColor: circleColor2,
      );
    }

    return Scaffold(
        backgroundColor: backgroundColor1,
        appBar: header(),
        body: Consumer<QuizNotifier>(
          builder: (_, value, __) {
            dynamic dataSoal = value.dataSoal();
            List jawaban = value.jawaban();
            int jumlahSoal = 0;
            int nilai = 0;
            if (dataSoal != null) {
              jumlahSoal = dataSoal[widget.getTopics].length;
              nilai = score(jawaban, dataSoal[widget.getTopics]);
            }

            return Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(color: backgroundColor1),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    circleScore(nilai, jumlahSoal),
                    const SizedBox(
                      height: 20,
                    ),
                    buttonShare(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Your Report',
                      style: primaryTextStyle.copyWith(
                          fontSize: 20, fontWeight: bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: correctionResult(
                            jawaban, dataSoal[widget.getTopics]),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Future<void> saveAndShare(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/ScoreQuizApp$time.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([(image.path)], text: "Score from Quiz App");
  }
}
