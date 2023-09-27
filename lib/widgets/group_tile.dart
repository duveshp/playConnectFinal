import 'package:flutter/material.dart';
import 'package:play_connect/pages/teamroom/chat_page.dart';
import 'package:play_connect/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  // bool _isLoading=false;
  // Stream? groups;
  // String groupId;
  // String userName="";
  // // String email="";
  // String groupName="";
  // String groupSports="";
  // String groupLocation="";
  // int? groupCapacity;
  // // AuthService authService=AuthService();
  // const GroupTile(Key? key, this.groupId,this.groupName,this.groupSports,this.groupCapacity,this.groupLocation,this.userName):super(key: key);
  final String userName;
  final String groupId;
  final String groupName;
  final Key? key;
  // final String groupSports;
  // final String groupLocation;
  const GroupTile(@required this.userName,@required this.groupId,@required this.groupName,{this.key}):super(key: key);
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
          widget.userName,
          widget.groupName,
          widget.groupId
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.sports_cricket,
            color: Colors.white,)
          ),
          title: Text(widget.groupName, style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}",
            style: TextStyle(
              fontSize: 12
          ),),
        ),

      ),
    );
  }
}
