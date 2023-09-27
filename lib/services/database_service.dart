import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  //ref for our collection
  final CollectionReference userCollection=FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection=FirebaseFirestore.instance.collection("groups");

  //updating the userdata
  Future savingUserData(String fullName, String email) async{
    return await userCollection.doc(uid).set({
    "fullName":fullName,
    "email":email,
    "groups":[],
    "profilePic":"",
    "uid":uid,
  });
  }

  //getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot= await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  //creating a group

  Future createTeamRoom(String userName, String id, String groupName,String groupSports ,String groupLocation, int groupCapacity) async{
    DocumentReference groupDocumentReference= await groupCollection.add({
      "groupName": groupName,
      "groupCapacity": groupCapacity+1,
      "groupLocation":groupLocation,
      "groupSports":groupSports,
      "groupIcon":"",
      "groupAdmin":"${id}_${userName}",
      "members":[],
      "groupId":"",
      "recentMessage":"",
      "recentMessageSender":"",
    });
    //updating the member
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_${userName}"]),
      "groupId": groupDocumentReference.id,


    });

    DocumentReference userDocumentReference=userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_${groupName}"])
    });

  }
  //getting the chats
  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }


  Future getGroupAdmin(String groupId) async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot= await d.get();
    return documentSnapshot['groupAdmin'];
  }

  //get group members
  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }

  //searching for teams
   groupSearchbyName(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
   }

   // function-> bool to hcekck user joined status
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName
      )async{
    DocumentReference userDocumentReference= userCollection.doc(uid);
    DocumentSnapshot documentSnapshot= await userDocumentReference.get();

    List<dynamic> groups=await documentSnapshot['groups'];
    if(groups.contains("${groupId}_${groupName}")){
      return true;
    }else{
      return false;
    }

  }

  //toggling the group join/exit
  Future toggleGroupJoin(String groupId, String userName, String groupName) async{
    //doc references
    DocumentReference userDocumentReference=userCollection.doc(uid);
    DocumentReference groupDocumentReference=groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot= await userDocumentReference.get();
    List<dynamic> groups= await documentSnapshot['groups'];

    //if user has our groups
    if (groups.contains("${groupId}_${groupName}")){
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }else{
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });

    }



  }

  //send message
  sendMessage(String groupId, Map<String, dynamic> chatMessagedata) async{
    groupCollection.doc(groupId).collection("messages").add(chatMessagedata);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessagedata['message'],
      "recentMessageSender":chatMessagedata['sender'],
      "recentMessageTime":chatMessagedata['time'].toString()
    });

  }
}









