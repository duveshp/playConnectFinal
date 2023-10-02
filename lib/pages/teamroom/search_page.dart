import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/teamroom/chat_page.dart';
import 'package:play_connect/services/groupchat_teams_service.dart';
import 'package:play_connect/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading=false;
  bool isJoined=false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched=false;
  String userName="";
  User? user;
  TextEditingController searchController= new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdAndName();
  }
  String getName(String r){
    // print(r.substring(r.indexOf("_")+1));
    return r.substring(r.indexOf("_")+1);

  }
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserNameFromSF().then((value){
      setState(() {
        userName=value!;
      });
    });
    user=FirebaseAuth.instance.currentUser;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Search",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Colors.white
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey.shade400,

            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController ,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search for teams...",
                      hintStyle: TextStyle(
                        color: Colors.white, fontSize: 16
                      )
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    print("U just tap on it!");
                    initiateSearchMehtod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),

                      ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading? const Center(child: CircularProgressIndicator(color: Colors.blueGrey,),)
              :groupList(),
        ],
      )
    );
  }
  initiateSearchMehtod() async {
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading=true;
      });
      await DatabaseService()
          .groupSearchbyName(searchController.text)
          .then((snapshot){
            setState(() {
              searchSnapshot=snapshot;
              isLoading=false;
              hasUserSearched=true;
            });

      });
    }
  }
  groupList(){
    return hasUserSearched
        ?ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, index){
        return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['groupAdmin'],
        );
      },

    )
        :Container();
  }
  joinedOrNot(String userName, String groupId, String groupName, String admin) async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined= value;
      });
    });
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin){
    // function to check whether user already exists in group
    joinedOrNot(userName,groupId,groupName,admin);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blueGrey,
        child: Text(
          groupName.substring(0,1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName,style: TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async{
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if(isJoined){
            setState(() {
              isJoined=!isJoined;
            });
            showSnackBar(context, Colors.green, "Successfully Joined the team");
            Future.delayed(const Duration(seconds: 2),(){
              nextScreen(context, ChatPage(userName, groupName, groupId));
          });
          }else{
            setState(() {
              isJoined=!isJoined;
              showSnackBar(context, Colors.red, "Left the team $groupName");
            });
          }

        },
        child: isJoined
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
            border: Border.all(
              color: Colors.white,width: 1,
            )
          ),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Text("Joined",style: TextStyle(
            color: Colors.white
          ),),
        ): Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey,width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Join Now", style: TextStyle(color: Colors.blueGrey),),
        ) ,
      ),
    );
  }
}
