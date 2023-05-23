import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/notifier/quiz_notifier.dart';
import 'package:quiz_game/views/result_quiz_page.dart';

import '../theme.dart';
import 'main_page.dart';

class QuizPage extends StatelessWidget {
  QuizPage({required this.getTopics});
  String? getTopics;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizNotifier>(builder: (_, value, __) {
      List<Widget> options(List opt) {
        List<Widget> lstWidget = [];
        for (var val in opt) {
          lstWidget.add(
            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Provider.of<QuizNotifier>(context, listen: false)
                      .updateSoal(val);
                },
                child: Text(
                  val,
                  style:
                      blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                ),
              ),
            ),
          );
        }
        return lstWidget;
      }

      dynamic dataSoal = value.dataSoal();

      List topics = value.dataTopics();

      if (getTopics == '' && topics.isNotEmpty) {
        Random random = Random();
        getTopics = topics[random.nextInt(topics.length)];
        print("selectTopics");
      }
      int urutanSoal = value.urutanSoal();

      int jumlahSoal = 0;
      if (dataSoal != null && getTopics != '') {
        jumlahSoal = dataSoal[getTopics].length;
      }

      Widget soal(String data) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(10, 30, 10, 20),
          child: Text('$data?'),
        );
      }

      return dataSoal != null
          ? (jumlahSoal != urutanSoal
              ? Scaffold(
                  backgroundColor: backgroundColor1,
                  appBar: AppBar(
                    backgroundColor: backgroundColor1,
                    centerTitle: true,
                    elevation: 0,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text(
                          'Exit',
                          style: primaryTextStyle.copyWith(
                              fontSize: 16, fontWeight: medium),
                        ),
                      )
                    ],
                    title: Text(
                      'Quiz Page',
                      style: titleTextStyle,
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(color: backgroundColor1),
                    child: Column(
                      children: [
                        Progressbar(),
                        soal(dataSoal[getTopics][urutanSoal]['question']),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                            children: options(
                                dataSoal[getTopics][urutanSoal]['option'])),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              : ResultQuizPage(
                  getTopics: getTopics,
                ))
          : Scaffold(
              backgroundColor: backgroundColor1,
              appBar: AppBar(
                backgroundColor: backgroundColor1,
                centerTitle: true,
                elevation: 0,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text(
                      'Exit',
                      style: primaryTextStyle.copyWith(
                          fontSize: 16, fontWeight: medium),
                    ),
                  )
                ],
                title: Text(
                  'Quiz Page',
                  style: titleTextStyle,
                ),
              ),
              body: Container(
                color: backgroundColor1,
                child: Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                )),
              ),
            );
    });
  }
}

class Progressbar extends StatefulWidget {
  // bool reset = false;
  // Progressbar({required bool reset});

  @override
  State<Progressbar> createState() => _ProgressbarState();
}

class _ProgressbarState extends State<Progressbar> {
  Duration duration = Duration();
  int detik = 0;
  Timer? timer;
  int setTimer = 31;
  int dummy = 0;
  runTimer() {
    const addSeconds = 1;
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        Provider.of<QuizNotifier>(context, listen: false).changeResetTimer();
        detik = duration.inSeconds + addSeconds;
        duration = Duration(seconds: detik);

        if (detik == setTimer) {
          detik = 0;
          duration = Duration(seconds: detik);
//aktifin klo screen udah jadi
          Provider.of<QuizNotifier>(context, listen: false).updateSoal('');
        }
        setState(() {
          // print(detik);
        });
      });
    }
  }

  double calculateTimer(int detik) {
    if (detik == 30) {
      return 1;
    } else {
      return 0.033 * detik;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runTimer();
  }

  restartTimer() {
    timer!.cancel();
    detik = 0;
    duration = Duration();
    runTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizNotifier>(builder: (_, value, __) {
      if (value.resetTimer) {
        restartTimer();
      }

      return LinearPercentIndicator(
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width * 1,
        lineHeight: 8.0,
        percent: calculateTimer(detik),
        progressColor: progressBarColor,
      );
    });
  }
}
