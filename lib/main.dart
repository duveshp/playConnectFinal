import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/pages/auth/login_page.dart';
import 'package:play_connect/pages/auth/register_page.dart';
import 'package:play_connect/pages/booking_page.dart';
import 'package:play_connect/pages/home_page.dart';
import 'package:play_connect/pages/notifications_page.dart';
import 'package:play_connect/pages/profile_page.dart';
import 'package:play_connect/pages/teamroom/teamroom_page.dart';

import 'package:flutter/foundation.dart';
import 'package:play_connect/pages/userForm.dart';
import 'package:play_connect/shared/constants.dart';

import 'helper/helper_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: Constants.apiKey,
        appId: Constants.appId,
        messagingSenderId: Constants.messagingSenderId,
        projectId: Constants.projectId));

  }else{
    await Firebase.initializeApp();
  }



  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  //Check if logged in or not
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await HelperFunction.getUserLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          _isSignedIn = value;
        });

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Connect',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: _isSignedIn ? UserForm():LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  //BottomNavigation Bar
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  // Define your screens here
  final List<Widget> _pages = [
    HomePage(),
    TeamRoomHomePage(),
    BookingPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: PageView(
        controller: _pageController,
        children: _pages, // Use the _pages list here
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        backgroundColor: Colors.blue, // Change the background color
        selectedItemColor: Colors.black, // Change the selected item color
        unselectedItemColor: Colors.grey, // Change the unselected item color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_sharp),
            label: 'Team Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball_sharp),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.home, size: 48.0), // Adjust icon size as needed
    );
  }
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.explore, size: 48.0), // Adjust icon size as needed
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.notifications, size: 48.0), // Adjust icon size as needed
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.person, size: 48.0), // Adjust icon size as needed
    );
  }
}

class TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.group_sharp, size: 48.0), // Adjust icon size as needed
    );
  }
}


//TRYING FOR APPBAR
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Horizontal Scrolling Containers'),
//         ),
//         body: ScrollingContainersRow(),
//       ),
//     );
//   }
// }
//
// class ScrollingContainersRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       // scrollDirection: Axis.horizontal, // Scroll horizontally
//       children: <Widget>[
//         SmallContainer(color: Colors.red),
//         SmallContainer(color: Colors.blue),
//         SmallContainer(color: Colors.green),
//         SmallContainer(color: Colors.orange),
//         SmallContainer(color: Colors.purple),
//         // Add more SmallContainer widgets as needed
//       ],
//     );
//   }
// }
//


