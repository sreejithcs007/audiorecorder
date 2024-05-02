import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../recordingpage/view/recordingpage.dart';

class HomepageScreen extends StatefulWidget{
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("RECORDER"),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width,
           color: Colors.white,
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      title: Text("TITLE"),
                      subtitle: Row(

                        children: [
                          Text("00:00:01"),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("1/05/2024"),
                          )

                        ],


                      ),
                      trailing: InkWell(
                        onTap: (){

                        },
                        child: Container(
                          height:  MediaQuery.of(context).size.height*.08,
                          width: MediaQuery.of(context).size.width*0.095,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(.5)
                          ),
                          child: Icon(Icons.play_arrow,color: Colors.black,),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: .6,
                        blurRadius: 4

                    )

                  ]
              ),
              child: Center(
                child: InkWell(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordingpageScreen()));
                  },
                  child: Container(
                      height:  MediaQuery.of(context).size.height*.1,
                      width: MediaQuery.of(context).size.width*0.2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow:[
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 4
                            )
                          ]
                      ),
                      child:  Icon(Icons.mic,color: Colors.red,size: MediaQuery.of(context).size.height*.05)),
                ),
              ),
            ),
          )
        ],

      ),

    );
  }
}