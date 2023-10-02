import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/profile_page.dart';
import 'package:play_connect/pages/teamroom/joined_teamrooms.dart';
import 'package:play_connect/pages/teamroom/search_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/services/groupchat_teams_service.dart';
import 'package:play_connect/widgets/widgets.dart';

class TeamRoomHomePage extends StatefulWidget {
  const TeamRoomHomePage({Key? key}) : super(key: key);

  @override
  State<TeamRoomHomePage> createState() => _TeamRoomHomePageState();
}

class _TeamRoomHomePageState extends State<TeamRoomHomePage> {
  bool _isLoading=false;
  Stream? groups;
  String userName="";
  String email="";
  String groupName="";
  String groupSports="";
  String groupLocation="";
  int? groupCapacity;
  AuthService authService=AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
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
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              nextScreen(context, const SearchPage());
            }, icon: Icon(Icons.search)),
            // IconButton(onPressed: (){
            //   nextScreen(context, ProfilePage());
            // }, icon: Icon(Icons.person_rounded)),

          ],
          title: Center(
            child: Text(
              'Team Room',
              style: TextStyle(),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Joined Teams'),
              Tab(text: 'Active Team Rooms'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Your tab content
            JoinedTeamRoom(),
            ActiveTeamRoomsContent(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: (){
              popUpDialog(context);
            },
          elevation:0,
          child: const Icon(Icons.add,color: Colors.white,size: 30),


            ),
      ),
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



}

// class JoinedTeamsContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace with your content for 'Joined Teams'
//     return Center(
//       child: Text('Joined Teams Content'),
//     );
//   }
// }

class ActiveTeamRoomsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with your content for 'Active Team Rooms'
    return Center(
      child: Text('Active Team Rooms Content'),
    );
  }
}

