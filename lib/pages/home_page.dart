import 'package:curved_container/curved_container.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/helper/helper_function.dart';
import 'package:play_connect/pages/profile_page.dart';
import 'package:play_connect/pages/teamroom/teamroom_page.dart';
import 'package:play_connect/services/auth_services.dart';
import 'package:play_connect/widgets/widgets.dart';

import '../models/playAreas.dart';
import '../services/api_service.dart';
import '../widgets/caros_home.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName="";
  String email="";
  AuthService authService=AuthService();
  List<PlayArea> playAreas = [];
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

  Future<void> fetchData() async{
    try{
      final data = await fetchPlayAreas();
      setState(() {
        playAreas = data;
      });
    }catch(e){
      print('Error fetching data: $e');
    }
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Implement search functionality here
          },),
        title: Text(
          'Play Connect',
          style: TextStyle(
            fontFamily: 'SportyFont', // Use your custom sporty font
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [


          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications functionality here
            },
          ),
        ],
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,// Customize the app bar background color
        elevation: 0, // Remove the app bar shadow
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                width: (MediaQuery.of(context).size.width),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("Hey ${userName},",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          margin: EdgeInsets.all(6),
                        ),
                        TextButton(onPressed: (){nextScreen(context, ProfilePage());}, child: Text("See more",style: TextStyle(color: Colors.white),))
                      ],
                    ),
                    Container(
                      height: 60,
                      color: Colors.blueGrey,
                      margin: EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(


                            child: Column(

                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 3.0,right: 3,top: 3,bottom: 5),
                                  child: Text("Bookings Done",style: TextStyle(fontSize: 12,color: Colors.blueGrey[900]),),
                                ),
                                Text("10",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                              ],

                            ),

                            decoration: BoxDecoration(
                                color: Colors.white60,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,

                              )
                            ),
                          ),
                          Container(


                            child: Column(

                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 3.0,right: 3,top: 3,bottom: 5),
                                  child: Text("Teams Joined",style: TextStyle(fontSize: 12,color: Colors.blueGrey[900]),),
                                ),
                                Text("5",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                              ],

                            ),

                            decoration: BoxDecoration(
                                color: Colors.white60,
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 2,

                                )
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 16,right: 8,top: 8,bottom: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Connect with other Players",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(onPressed: (){},child: Text("View more", style: TextStyle(color: Colors.black),))
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        nextScreen(context, TeamRoomHomePage());
                      },
                      child: Container(
                        height: 85,
                        child: Image.asset('assets/chatBanner.png',fit: BoxFit.fitWidth,)


                      ),
                    )
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 8,left: 16),
                child: Text("Book and Explore by Sports",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,


                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // margin: EdgeInsets.only(bottom: 8,left: 8),
                  child: Column(

                    children: [

                      Row(
                        children: [
                          Container(
                            width: 70.0, // Width of the small container
                            height: 70.0, // Height of the small container
                            margin: EdgeInsets.all(8.0),
                            child: Image.asset('assets/CRICKET.png'),
                          ),
                          Container(
                            width: 70.0, // Width of the small container
                            height: 70.0, // Height of the small container
                            margin: EdgeInsets.all(8.0),
                            child: Image.asset('assets/football.png'),
                          ),
                          Container(
                            width: 70.0, // Width of the small container
                            height: 70.0, // Height of the small container
                            margin: EdgeInsets.all(8.0),
                            child: Image.asset('assets/basketball.png'),
                          ),
                          Container(
                            width: 70.0, // Width of the small container
                            height: 70.0, // Height of the small container
                            margin: EdgeInsets.all(8.0),
                            child: Image.asset('assets/badminton.png'),
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 8,left: 16),
                child: Text("Popular Play Areas",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,


                  ),
                ),
              ),
              PlayAreaCarousel(playAreas: playAreas),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 8,left: 16),
                child: Text("Upcoming events",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,


                  ),
                ),
              ),
              PlayAreaCarousel(playAreas: playAreas),

            ],
          ),
        ),
      ),
    );
  }
}


class SmallContainer extends StatelessWidget {
  final Color color;
  final AssetImage img;
  final Key? key;

  const SmallContainer(@required this.color,@required this.img,{this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0, // Width of the small container
      height: 70.0, // Height of the small container
      margin: EdgeInsets.all(8.0), // Adjust spacing between containers

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,

      ),

      // Add content or decoration as needed
    );
  }
}
