import 'dart:async';


import 'package:audiorecorder/controller/reccontroller.dart';
import 'package:audiorecorder/model/model_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class RecordingpageScreen extends StatefulWidget {
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

  var textcontroller = TextEditingController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    print("Timertext $timerText");

    print("filename:  $fileName");
    print("Total duration $_totalDuration");
    print("filepath $_filePath");
    print("date $date");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text("New recording "),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4)
            ),

          ),
          Text(
            timerText,
            style: TextStyle(fontSize: 25),
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
                    decoration: BoxDecoration(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("press start button")));
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
                child: Align(
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
                  decoration: InputDecoration(border: OutlineInputBorder()),
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
                      shape: StadiumBorder(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    MaterialButton(
                      color: Colors.green,
                      shape: StadiumBorder(),
                      onPressed: () {
                        var value = Modelclasss(
                          name: textcontroller.text,
                          location: _filePath,
                          date: date,
                        );
                        Provider.of<Reccontroller>(context, listen: false)
                            .savedata(value);

                        Navigator.pop(context);
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
