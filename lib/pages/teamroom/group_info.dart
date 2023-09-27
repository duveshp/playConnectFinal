import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/pages/teamroom/teamroom_page.dart';
import 'package:play_connect/services/database_service.dart';
import 'package:play_connect/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final Key? key;
  const GroupInfo(@required this.groupId,@required this.groupName,@required this.adminName,{this.key}):super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
  }

  getMembers() async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val){
          setState(() {
            members=val;
          });
    });
  }

  String getName(String r){
    print(r.substring(r.indexOf("_")+1));
    return r.substring(r.indexOf("_")+1);

  }
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Group Info"),
        actions: [

          IconButton(onPressed: (){
            print(getName(widget.adminName));
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context){
                  return AlertDialog(

                    title: const Text("Exit"),
                    content: const Text("Are you sure you want to exit"),
                    actions: [
                      IconButton(
                          onPressed:() {
                            print(widget.adminName);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          )),
                      IconButton(
                          onPressed:() async {
                            print(widget.adminName);
                            DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(widget.groupId, getName(widget.adminName), widget.groupName)
                                .whenComplete(() {

                                  nextScreenReplace(context, TeamRoomHomePage());
                            });
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 18,
                          )),

                    ],
                  );
                });
          },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey.withOpacity(0.2)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueGrey ,
                    child: Icon(Icons.sports_cricket,color: Colors.white,),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group Name:",
                      style: TextStyle(fontWeight: FontWeight.w300,),
                      ),
                      const SizedBox(height: 2,),
                      Text("${widget.groupName}",
                        style: TextStyle(fontWeight: FontWeight.w500,),
                      ),
                      const SizedBox(height: 5,),
                      Text("Admin: ${getName(widget.adminName)}")

                    ],

                  )

                ],
              ),
            ),
            Expanded(child: memberList()),

          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members']!=null){
            if(snapshot.data['members'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),

                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])) ,
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );

            }else{
              return const Center(child: CircularProgressIndicator(color: Colors.blueAccent,) ,);

            }
            
          }else{
            return Center(child: Text("No Members"),);
          }

        }else{
          return const Center(child: CircularProgressIndicator(color: Colors.blueGrey,) ,);
        }
      },
    );

  }
}
