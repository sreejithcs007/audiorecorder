import 'package:flutter/material.dart';

class RecordingpageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        title: Text("New recording "),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          ),

          Text("00:00:00"),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow,color: Colors.black,size: MediaQuery.of(context).size.height*.05)),
              InkWell(
                onTap: (){

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
                    child:  Icon(Icons.circle,color: Colors.red,size: MediaQuery.of(context).size.height*.05)),
              ),

              IconButton(onPressed: (){}, icon: Icon(Icons.stop,color: Colors.black,size: MediaQuery.of(context).size.height*.05,))
            ],
          )
        ],
      ),
    );
  }


}