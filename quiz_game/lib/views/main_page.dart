import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/views/quiz_page.dart';
import 'package:quiz_game/views/topicsPage.dart';

import '../notifier/quiz_notifier.dart';
import '../theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tag() {
      return Text(
        'Learn \u2022 Take Quiz \u2022 Repeat',
        style: primaryTextStyle.copyWith(fontSize: 10, fontWeight: medium),
      );
    }

    Widget playButton() {
      return Container(
        height: 50,
        width: 300,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: backgroundColor2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<QuizNotifier>(
                      create: (context) => QuizNotifier(),
                      child: Builder(builder: (BuildContext context) {
                        return QuizPage(
                          getTopics: '',
                        );
                      })),
                ));
          },
          child: Text(
            'PLAY',
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
      );
    }

    Widget topicsButton() {
      return Container(
        height: 50,
        width: 300,
        margin: const EdgeInsets.only(top: 15),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: backgroundColor2,
                      width: 2,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<QuizNotifier>(
                      create: (context) => QuizNotifier(),
                      child: Builder(builder: (BuildContext context) {
                        return const TopicsPage();
                      })),
                ));
          },
          child: Text(
            'TOPICS',
            style: blueTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
      );
    }

    Widget shareButton() {
      return GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Fitur ini masih dalam pengembangan'),
          ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.share,
              color: backgroundColor2,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Share',
              style:
                  primaryTextStyle.copyWith(fontSize: 13, fontWeight: medium),
            ),
          ],
        ),
      );
    }

    Widget rateButton() {
      return GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Fitur ini masih dalam pengembangan'),
          ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.star_rate,
              color: ratingColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Rate Us',
              style:
                  primaryTextStyle.copyWith(fontSize: 13, fontWeight: medium),
            ),
          ],
        ),
      );
    }

    Widget footer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          shareButton(),
          const SizedBox(
            width: 30,
          ),
          rateButton(),
        ],
      );
    }

    Widget screen() {
      return Scaffold(
        backgroundColor: backgroundColor1,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/idea.png',
              width: 100,
              height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Flutter Quiz App',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            const SizedBox(
              height: 10,
            ),
            tag(),
            playButton(),
            topicsButton(),
            const SizedBox(
              height: 50,
            ),
            footer(),
          ],
        ),
      );
    }

    return screen();
  }
}
