import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class QuizNotifier extends ChangeNotifier {
  int objUrutanSoal = 0;
  List objJawaban = [];
  int jumlahSoal = 0;
  bool resetTimer = false;
  List objTopics = [];
  Map<String, dynamic>? objDataSoal;
  QuizNotifier() {
    init();
  }
  init() async {
    await getData();
  }

  dataSoal() => objDataSoal;
  dataTopics() => objTopics;
  urutanSoal() => objUrutanSoal;
  jawaban() => objJawaban;
  reset() => resetTimer;
  getJumlahSoal() => jumlahSoal;

  updateSoal(String? jwb) {
    print('updateds');
    objJawaban.add(jwb);
    objUrutanSoal++;
    resetTimer = true;
    notifyListeners();
  }

  changeResetTimer() {
    resetTimer = false;
  }

  Future<void> getData() async {
    FirebaseFirestore.instance.collection('topics').get().then(
      (value) {
        value.docs.forEach((result) {
          objDataSoal = Map<String, dynamic>.from(result.data());
          objTopics = List.from(objDataSoal!.keys);

          if (objDataSoal != null && objTopics.isNotEmpty) {
            notifyListeners();
          }
        });
      },
    );
  }
}
