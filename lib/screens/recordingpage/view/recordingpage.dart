import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingpageScreen extends StatefulWidget {
  @override
  State<RecordingpageScreen> createState() => _RecordingpageScreenState();
}

class _RecordingpageScreenState extends State<RecordingpageScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;
  late Timer _timer;
  int _elapsedtime =0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer(){

    _timer =Timer.periodic(Duration(seconds: 1), (timer) {

      setState(() {
        _elapsedtime ++ ;
      });
    });


  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _audioRecorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    String fileName = "recording_${DateTime.now().millisecondsSinceEpoch}.mp";
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

    String timerText = "${(_elapsedtime ~/ 3600).toString().padLeft(2, '0')}:${((_elapsedtime ~/ 60) % 60).toString().padLeft(2, '0')}:${(_elapsedtime % 60).toString().padLeft(2, '0')}";

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
            color: Colors.grey,
          ),
          Text(timerText,style: TextStyle(fontSize: 25),),
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
                            color: Colors.grey, spreadRadius: 1, blurRadius: 4)
                      ]),
                  child:_isRecording==true? Icon(Icons.pause,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height * .05):
                  Icon(Icons.play_arrow,color: Colors.red,size: MediaQuery.of(context).size.height*.05)
                ),
              ),
              IconButton(
                  onPressed: () {
                    _isRecording == true ? _stopRecording() : null;
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
}
