

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import '../model/model_class.dart';

class Reccontroller extends ChangeNotifier{

  List<Modelclasss> records = [];
  List<Modelclasss> revrecords = [];

  var box = Hive.box('mybox');


  void delete(int index) {


    box.deleteAt(index);

    getalldetails();
    notifyListeners();
  }



  void savedata(Modelclasss value1) {
    box.add(value1);
    records.addAll(box.values.map((value) => value));
    revrecords = records.reversed.toList();

    print("data = $revrecords");
    getalldetails();

    notifyListeners();


  }

  void getalldetails(){

    records.clear();
    revrecords.clear();

    records.addAll(box.values.map((value) => value));
    revrecords = records.reversed.toList();

    notifyListeners();
  }

  void sharee(String? file, String? nme,)async{

    await Share.shareXFiles([XFile(file!)],text: nme);
  }


}