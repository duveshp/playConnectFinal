

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/teamroom/teamroom_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/services/groupchat_teams_service.dart';
import 'package:play_connect/widgets/group_tile.dart';
import 'package:play_connect/widgets/widgets.dart';

class JoinedTeamRoom extends StatefulWidget {
  const JoinedTeamRoom({super.key});

  @override
  State<JoinedTeamRoom> createState() => _JoinedTeamRoomState();
}

class _JoinedTeamRoomState extends State<JoinedTeamRoom> {
  bool _isLoading=false;
  Stream? groups;
  String userName="";
  String email="";
  String groupName="";
  String groupSports="";
  String groupLocation="";
  int? groupCapacity;
  AuthService authService=AuthService();

  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });


    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groupList(),
    );
  }

//------------------------------------------
  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        //make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups']!=null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index){
                  int reverseIndex= snapshot.data['groups'].length-index-1;
                    return GroupTile(
                        snapshot.data['fullName'],getId(snapshot.data['groups'][reverseIndex]),getName(snapshot.data['groups'][reverseIndex]));
                  });

            }else{
              print("length 0");
              return noGroupWidget();
            }

          }else{
            print("null");
            return noGroupWidget();

          }

        }else{

          return Center(

            child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
          );
        }
      },

    );
    
  }
  popUpDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Create a Team Room", textAlign: TextAlign.center ,),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading ==true) Center(child: CircularProgressIndicator(color: Colors.black,),) else Column(
                        children: [
                          TextFormField(
                    onChanged: (val){
                          setState(() {
                            groupName=val;
                          });

                    },
                    style: TextStyle(color: Colors.deepPurple),
                    decoration: InputDecoration(
                          label: Text("Enter a group name"),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,),
                            borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black,),
                              borderRadius: BorderRadius.circular(20),
                            )
                    ),
                  ),
                          SizedBox(height: 5,),
                          TextFormField(
                            onChanged: (val){
                              setState(() {
                                groupLocation=val;
                              });

                            },
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                label: Text("Enter your team location"),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            onChanged: (val){
                              setState(() {
                                groupSports=val;
                              });

                            },
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                label: Text("Enter Sports Name"),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            onChanged: (val){
                              setState(() {
                                groupCapacity=int.tryParse(val);
                              });

                            },
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                label: Text("Number of participants you're looking for:"),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,),
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("CANCEL"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
              ),
              ElevatedButton(
                onPressed: () async{
                  if(groupName!=""){
                    setState(() {
                      _isLoading=true;
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createTeamRoom(userName, FirebaseAuth.instance.currentUser!.uid, groupName, groupSports, groupLocation, groupCapacity!)
                          .whenComplete(() => _isLoading=false);
                    });
                    Navigator.of(context).pop();
                    showSnackBar(context, Colors.green, "Group created successfully.");
                  }

                },
                child: const Text("CREATE"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
              )
            ],

          );
        });
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
              child: Icon(Icons.add_circle,color: Colors.black, size: 75,)),
          const SizedBox(height: 20,),
          Container(
            alignment: Alignment.center,
            child: const Text("You've not join any Team yet, press on add icon to create your  own team room or Join any from Active Team rooms tab",
              textAlign: TextAlign.center,style: TextStyle(),),
          ),


        ],
      ),
    );
  }
}


