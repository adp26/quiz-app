import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/views/quiz_page.dart';
import '../notifier/quiz_notifier.dart';
import '../theme.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({Key? key}) : super(key: key);

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> optionTopic(List topics) {
      List<Widget> lstWidget = [];
      for (var data in topics) {
        lstWidget.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<QuizNotifier>(
                      create: (context) => QuizNotifier(),
                      child: Builder(builder: (BuildContext context) {
                        return QuizPage(
                          getTopics: data,
                        );
                      })),
                ));
          },
          child: Container(
              margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data,
                      style: primaryTextStyle.copyWith(
                          fontSize: 16, fontWeight: medium),
                    ),
                  ),
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.grey,
                  )
                ],
              )),
        ));
      }
      return lstWidget;
    }

    AppBar header() {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor1,
        title: Text(
          'Topics',
          style: titleTextStyle,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: Container(
          padding: const EdgeInsets.only(top: 20),
          color: backgroundColor1,
          child: Consumer<QuizNotifier>(builder: (_, value, __) {
            List topics = value.dataTopics();

            return topics.isNotEmpty
                ? ListView(
                    children: optionTopic(topics),
                  )
                : Container(
                    color: backgroundColor1,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    )),
                  );
          })),
    );
  }
}
