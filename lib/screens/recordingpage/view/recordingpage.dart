import 'dart:async';
import 'package:audiorecorder/controller/reccontroller.dart';
import 'package:audiorecorder/model/model_class.dart';
import 'package:audiorecorder/screens/homepage/view/homepageview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class RecordingpageScreen extends StatefulWidget {
  const RecordingpageScreen({super.key});

  @override
  State<RecordingpageScreen> createState() => _RecordingpageScreenState();
}

class _RecordingpageScreenState extends State<RecordingpageScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  String? date;

  bool _isRecording = false;
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;
  late Timer _timer;
  int _elapsedtime = 0;
  String? fileName;
  String? key;

  var textcontroller = TextEditingController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedtime++;
      });
    });
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _audioRecorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    fileName = "recording_${DateTime.now().millisecondsSinceEpoch}.mp";
    key = "${DateTime.now().millisecondsSinceEpoch}";
    date = DateFormat('dd-MM-yyyy ').format(DateTime.now());
    _filePath = "${directory.path}/$fileName";

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );

    await _audioRecorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
    });
    _startTimer();
  }

  Future<void> _stopRecording() async {
    final path = _audioRecorder.stop();
    setState(() {
      _isRecording = false;
    });
    _timer.cancel();
  }

  Future<void> _playRecording() async {
    if (_filePath != null) {
      await _audioPlayer.setFilePath(_filePath!);
      _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
      _audioPlayer.play();

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String timerText =
        "${(_elapsedtime ~/ 3600).toString().padLeft(2, '0')}:${((_elapsedtime ~/ 60) % 60).toString().padLeft(2, '0')}:${(_elapsedtime % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[100],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text("New recording "),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _isRecording == true
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset(
                      "assets/animation/Animation - 1714839713001.json"))
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.26,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                      image: AssetImage(
                          "assets/image/8399350_mic_microphone_audio_icon.png"))),
          Text(
            timerText,
            style: const TextStyle(fontSize: 45,fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    !_isRecording ? _playRecording() : null;
                  },
                  icon: Icon(Icons.play_arrow,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.height * .05)),
              InkWell(
                onTap: () {
                  _isRecording ? _stopRecording() : _startRecording();
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 4)
                        ]),
                    child: _isRecording == true
                        ? Icon(Icons.pause,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.height * .05)
                        : Icon(Icons.play_arrow,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.height * .05)),
              ),
              IconButton(
                  onPressed: () {
                    if (_elapsedtime > 0) {
                      _isRecording == true ? _stopRecording() : null;
                      setState(() {
                        textcontroller.text = fileName ?? " ";
                      });
                      bottomsheet(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("press start button"),
                        backgroundColor: Colors.lightBlueAccent,
                      ));
                    }
                  },
                  icon: Icon(
                    Icons.stop,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height * .05,
                  ))
            ],
          ),
          Slider(
            value: _currentPosition,
            max: _totalDuration,
            onChanged: (value) {
              setState(() {
                _currentPosition = value;
              });
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
        ],
      ),
    );
  }

  void bottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.05),
                child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "File Name",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    top: MediaQuery.of(context).size.height * 0.009,
                    right: MediaQuery.of(context).size.width * 0.05),
                child: TextFormField(
                  controller: textcontroller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.009),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      color: Colors.red,
                      shape: const StadiumBorder(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    MaterialButton(
                      color: Colors.green,
                      shape: const StadiumBorder(),
                      onPressed: () {
                        var value = Modelclasss(
                          name: textcontroller.text,
                          location: _filePath,
                          date: date,
                          key: key!,
                        );
                        Provider.of<Reccontroller>(context, listen: false)
                            .savedata(value);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomepageScreen()),
                            (route) => false);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
