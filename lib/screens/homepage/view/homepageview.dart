import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../controller/reccontroller.dart';
import '../../recordingpage/view/recordingpage.dart';

class HomepageScreen extends StatefulWidget {
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {

  var box = Hive.box('mybox');

  final AudioPlayer _audioPlayer = AudioPlayer();
  double totalduration = 0;
  double _currentposition = 0;
  var filePath;

  var isplaying = false;

  Future<void> _playRecording(String? flnme) async {
    filePath = flnme;
    if (filePath != null) {
      await _audioPlayer.setFilePath(filePath!);
      totalduration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
      _audioPlayer.play();
_currentposition = 0;
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentposition = position.inSeconds.toDouble();
        });
      });

    }
    _audioPlayer.playerStateStream.listen((event) {
  if(event.processingState == ProcessingState.completed){
    setState(() {
      _currentposition = 0;
      isplaying = false;
    });
  }

    });

  }

  Future<void> pauserecording() async {
    _audioPlayer.pause();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Reccontroller>(context, listen: false).getalldetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Reccontroller>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("RECORDER"),
      ),
      body: Consumer<Reccontroller>(
        builder: (BuildContext context, Reccontroller value, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ListView.builder(
                    itemCount: provider.revrecords.length,
                    itemBuilder: (context, index) {
                      print(provider.revrecords[index].name ?? " ");
                      return Card(
                        child: ExpansionTile(
                          title: Text(provider.revrecords[index].name ?? " "),
                          subtitle: Text(
                              provider.revrecords[index].date ?? " No"),
                          trailing: Text(""),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      provider.selectedAudioIndex = index;
                                    });
                                    setState(() {
                                      isplaying = !isplaying;
                                    });

                                    var flnme = Provider.of<Reccontroller>(
                                            context,
                                            listen: false)
                                        .revrecords[index]
                                        .location;
                                    isplaying == false
                                        ? pauserecording()
                                        : _playRecording(flnme);
                                  },
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .08,
                                      width: MediaQuery.of(context).size.width *
                                          0.095,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(.5)),
                                    child: (provider.selectedAudioIndex == index && isplaying)
                                        ? IconButton(
                                      onPressed: () {
                                        pauserecording();
                                        setState(() {
                                          isplaying = false;
                                        });
                                      },
                                      icon: Icon(Icons.pause, color: Colors.black),
                                    )
                                        : (provider.selectedAudioIndex == index)
                                        ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isplaying = true;
                                        });
                                        var flnme = Provider.of<Reccontroller>(context, listen: false)
                                            .revrecords[index]
                                            .location;
                                        _playRecording(flnme);
                                      },
                                      icon: Icon(Icons.play_arrow, color: Colors.black),
                                    )
                                        : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          provider.selectedAudioIndex = index;
                                          isplaying = true;
                                        });
                                        var flnme = Provider.of<Reccontroller>(context, listen: false)
                                            .revrecords[index]
                                            .location;
                                        _playRecording(flnme);
                                      },
                                      icon: Icon(Icons.play_arrow, color: Colors.black),
                                    ),

                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: (provider.selectedAudioIndex == index)? Slider(
                                    value: _currentposition,
                                    max: totalduration,
                                    onChanged: (value) {
                                      setState(() {
                                        _currentposition = value;
                                      });
                                      _audioPlayer.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                  ):  Slider(value: 0, onChanged: (val){
                                    return null;
                                  }),
                                ),
                                PopupMenuButton(itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        child: IconButton(
                                            onPressed: () {

                                              Provider.of<Reccontroller>(context, listen: false).delete(index);
                                              Navigator.pop(context);


                                            },
                                            icon: Row(
                                              children: [
                                                Icon(Icons.delete),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                Text(
                                                  "delete",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                )
                                              ],
                                            ))),
                                    PopupMenuItem(
                                        child: IconButton(
                                            onPressed: () {

                                              var file = provider.revrecords[index].location;
                                              var nme = provider.revrecords[index].name;

                                              provider.sharee(file,nme);

                                            },
                                            icon: Row(
                                              children: [
                                                Icon(Icons.share),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                Text(
                                                  "Share",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                )
                                              ],
                                            )))
                                  ];
                                })
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, spreadRadius: .6, blurRadius: 4)
                      ]),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingpageScreen()));
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
                          child: Icon(Icons.mic,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.height * .05)),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
