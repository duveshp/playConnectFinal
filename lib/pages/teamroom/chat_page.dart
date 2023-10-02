import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/pages/teamroom/group_info.dart';
import 'package:play_connect/services/groupchat_teams_service.dart';
import 'package:play_connect/widgets/message_tile.dart';
import 'package:play_connect/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final Key? key;

  const ChatPage(@required this.userName,@required this.groupName,@required this.groupId, {this.key} ) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin="";
  TextEditingController messageController= new TextEditingController();

  @override
  void initState() {
    getChatAndAdmin();
    // TODO: implement initState
    super.initState();
  }

  getChatAndAdmin(){
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val){
      setState(() {
        admin=val;
        print(admin);
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupInfo(widget.groupId,widget.groupName,admin));
          }, 
              icon: Icon(Icons.info_outline,color: Colors.white,))
        ],

      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,

            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.white
                    ),

                  )),
                  const SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),

                    ),
                  )
                ],
              ),

            ),
          )
        ],
      ),

    );
  }
  chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData
            ?ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.docs[index]['message'],
                snapshot.data.docs[index]['sender'],
                widget.userName==snapshot.data.docs[index]['sender']);
          },
        )
            : Container();
      },
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> chatMessageMap={
        "message": messageController.text,
        "sender": widget.userName,
        "time":DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId,chatMessageMap);
    }
    setState(() {
      messageController.clear();
    });


  }
}

