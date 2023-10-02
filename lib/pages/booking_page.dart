import 'package:flutter/material.dart';
import 'package:play_connect/calendar_page.dart';
import 'package:play_connect/cart.dart';
import 'package:play_connect/pages/bookingForm.dart';
import 'package:play_connect/store.dart';
import 'package:play_connect/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/playAreas.dart';
import '../services/api_service.dart';
import '../widgets/playAreaList.dart';
import 'package:intl/intl.dart';

final baseImageUrl = "http://192.168.0.103:8000/restfinal";

class BookingPage extends StatefulWidget {

  @override
  _BookingPageState createState() => _BookingPageState();
}
class _BookingPageState extends State<BookingPage> {

  late Future<List<PlayArea>> _playAreas;



  Future<void> _showConfirmationDialog(BuildContext context, DateTime selectedDate) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text('Your booking has been confirmed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    _playAreas = fetchPlayAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Areas'),
      ),
      body: FutureBuilder<List<PlayArea>>(
        future: _playAreas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Use a custom loading widget if needed
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      print(snapshot);
                      setState(() {
                        _playAreas = fetchPlayAreas(); // Retry fetching data on button press
                      });
                    },
                    child: Text('Retry'),

                  ),
                ],
              ),
            );
          } else {
            final playAreas = snapshot.data;

            if (playAreas != null && playAreas.isNotEmpty) {
              return ListView.builder(
                itemCount: playAreas.length,
                itemBuilder: (context, index) {
                  final playArea = playAreas[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blueGrey[100],
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(playArea.playAreaSports,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(height:20,width:20,child: Icon(Icons.location_on,color: Colors.blueGrey,)),
                                SizedBox(width: 3,),
                                Text(playArea.playAreaLocation, style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w500),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),

                        Container(
                          height: 150,
                          // padding: EdgeInsets.all(10),
                          // margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.blueGrey[100],
                          child: Image.network(baseImageUrl+playArea.playAreaImageUrl,fit: BoxFit.contain),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(playArea.playAreaName,style: TextStyle(color:Colors.blueGrey[900],fontSize: 16,fontWeight: FontWeight.w600),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("4.5", style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w500),),
                                SizedBox(width: 3,),
                                Container(height:20,width:20,child: Icon(Icons.reviews,color: Colors.blueGrey,)),

                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            print("pressed BookNow");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingForm(playArea.playAreaName,playArea.playAreaVendor),));;
                          },
                          child: Container(
                            height: 50,

                            color: Colors.blueGrey,
                            alignment: Alignment.center,
                            child: Text("BOOK NOW",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            ),
                          ),
                        )

                      ],
                    ),
                  );
                  // return ListTile(
                  //   title: Text(playArea.playAreaName),
                  //   subtitle: Text(playArea.playAreaLocation),
                  //   leading: Image.network(baseImageUrl+playArea.playAreaImageUrl), // Display image from URL
                  // );
                },
              );
              //---------------------------
              // return ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: playAreas.length,
              //   itemBuilder: (context,index) {
              //     final playArea = playAreas[index];
              //     return InkWell(
              //         onTap:() => Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context)=> AreaDetailPage(
              //                   playArea: playArea)
              //           ),
              //         ),
              //         // child: CatalogPlayArea(playArea: playArea)
              //     );
              //   },
              // );

            } else {
              return Center(
                child: Text('No play areas available.'),
              );
            }
          }
        },
      ),
    );
  }
}


// class CatalogPlayArea extends StatelessWidget {
//   final PlayArea playArea;
//   const CatalogPlayArea({Key? key, required this.playArea}):
//         assert(playArea!=null),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
//     return Container(
//       margin: EdgeInsets.only(top: 16),
//       child: VxBox(
//
//           child: Column(
//
//             children: [
//               10.heightBox,
//               Hero(
//                   tag: Key(playArea.id.toString()),
//                   child: Image.network(baseImageUrl+playArea.playAreaImageUrl).py8()
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   "${playArea.playAreaName}".text.color(Colors.blueGrey).xl.bold.make().px12(),
//                   // "${playArea.playAreaSports}".text.color(MyTheme.darkBluishColor).textStyle(context.captionStyle).make().px12(),
//                   ButtonBar(
//                     children: [
//                       "Rs.${playArea.playAreaPrice}".text.color(context.cardColor).bold.medium.make(),
//                       AddToCart(playArea: playArea),
//                     ],
//                   )
//                 ],
//               )
//             ],
//
//           )
//       ).color(Theme.of(context).brightness == Brightness.dark
//           ? Colors.black
//           : Colors.white,).rounded.height(150).make().wFull(context),
//     );
//   }
// }


class AreaDetailPage extends StatelessWidget {
  final PlayArea playArea;

  const AreaDetailPage({Key? key, required this.playArea})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            "Rs.${playArea?.playAreaPrice}".text.bold.xl3.red800.make(),
            ElevatedButton(
              onPressed: () {},
              child: "Book Now".text.lg.color(Colors.white).make(),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(StadiumBorder()),
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
              ),
            ).wh(100, 60).px8(),
            AddToCart(playArea: playArea,).wh(100, 40),
          ],
        ).p(16),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: Key(playArea?.id.toString() ?? ""),
              child: Image.network(baseImageUrl+playArea.playAreaImageUrl?? "", fit: BoxFit.fill)
                  .wFull(context)
                  .p16()
                  .h32(context),
            ),
            Expanded(
              child: VxArc(
                height: 25,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  color: Colors.white,
                  width: context.screenWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        "${playArea?.playAreaName}".text.xl4.color(Colors.blueGrey).bold.make().px12(),
                        "${playArea?.playAreaSports}".text.textStyle(context.captionStyle).xl.make().px12(),
                        25.heightBox,
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                            .text
                            .make()
                            .p16(),
                      ],
                    ).py32(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCart extends StatelessWidget {
  final PlayArea playArea ;

  AddToCart({super.key, required this.playArea});


  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    // VxState.listen(context, to: [AddMutation]);
    final CartModel _cart= (VxState.store as MyStore).cart;


    bool isInCart=_cart.playAreas.contains(playArea)??false;

    return ElevatedButton(
      onPressed: (){
        if(!isInCart){
          AddMutation(playArea);
          // setState(() {});
        }


        isInCart? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart successfully.")))
            :ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed from cart.")));
      },
      child: isInCart? Icon(Icons.bookmark_added_outlined):"Add to Cart".text.lg.make(),
      style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
      ),
    );
  }
  Future<void> _showBookingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book Now'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Add form fields for date, from time, and to time here
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'From Time'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'To Time'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform booking logic here
                // Show the confirmation dialog
                _showConfirmationDialog(context);
              },
              child: Text('Book'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text('Your booking has been confirmed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


