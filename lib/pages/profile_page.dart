import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/auth/login_page.dart';
import 'package:play_connect/pages/my_bookings.dart';
import 'package:play_connect/pages/notifications_page.dart';
import 'package:play_connect/pages/teamroom/teamroom_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  // String userName;
  // String email;
  // ProfilePage(Key? key, this.email, this.userName) : super(key: key);



  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName="";
  String email="";
  AuthService authService=AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email=value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName=value!;
      });
    });

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.blueGrey, // Set app bar background color
      ),
      backgroundColor: Colors.white, // Set page background color
      body: GestureDetector(
        onTap: (){
          showSnackBar(context, Colors.deepPurple, "Feature to be unlocked soon.");
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueGrey[600],
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TeamRoomHomePage(),));
                },
                child: Container(

                  child: ListTile(
                    title: Text(
                      'Teams Joined',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    leading: Icon(
                      Icons.group,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                    onTap: () {
                      nextScreen(context, TeamRoomHomePage());
                      // Navigate to the Teams Joined page
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  showSnackBar(context, Colors.deepPurple, "Feature to be unlocked soon.");
                },
                child: ListTile(
                  title: Text(
                    'Booking History',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  leading: Icon(
                    Icons.history,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  onTap: () {
                    nextScreen(context, MyBookingsPage());
                    // Navigate to the Booking History page
                  },
                ),
              ),
              GestureDetector(
                onTap: (){
                  showSnackBar(context, Colors.deepPurple, "Feature to be unlocked soon.");
                },
                child: ListTile(
                  title: Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  leading: Icon(

                    Icons.edit,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  onTap: () {
                    // Navigate to the Update Profile page
                  },
                ),
              ),
              GestureDetector(
                onTap: (){
                  showSnackBar(context, Colors.deepPurple, "Feature to be unlocked soon.");
                },
                child: ListTile(
                  title: Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  leading: Icon(
                    Icons.thumb_up,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  onTap: () {
                    // Implement Follow Us functionality
                  },
                ),
              ),
              InkWell(
                onTap: (){
                  showSnackBar(context, Colors.deepPurple, "Feature to be unlocked soon.");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(),));
                },
                child: ListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  onTap: () {
                    // Navigate to the Notifications page
                    nextScreen(context, NotificationsPage());
                  },
                ),
              ),
              ListTile(
                title: ElevatedButton(

                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    alignment: Alignment.center,


                  ),
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context){
                          return AlertDialog(

                            title: const Text("Logout"),
                            content: const Text("Are you sure you want to Logout?"),
                            actions: [
                              IconButton(
                                  onPressed:() {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 18,
                                  )),
                              IconButton(
                                  onPressed:() async {
                                    await authService.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()),
                                            (route) => false);
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
                  child: Text('Log Out',style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),),


                ),
                // leading: Icon(
                //   Icons.exit_to_app,
                //   color: Colors.red,
                //   size: 30,
                // ),
                onTap: () {
                  // Implement Log Out functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
