import 'package:audiorecorder/controller/reccontroller.dart';
import 'package:audiorecorder/model/model_class.dart';
import 'package:audiorecorder/screens/homepage/view/homepageview.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ModelclasssAdapter());
  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Reccontroller())
      ],
      child: MaterialApp(
        home:  HomepageScreen(),
      ),
    );
  }
}


