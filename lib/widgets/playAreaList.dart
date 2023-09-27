import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_connect/models/playAreas.dart';

class PlayAreaListItem extends StatelessWidget {
  final PlayArea playArea;

  PlayAreaListItem({required this.playArea});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle play area booking when a list item is tapped
      },
      child: Container(
        height: 300,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey),
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(playArea.playAreaSports, style: TextStyle(fontSize: 15.0)),
                    SizedBox(width: 5.0),
                    Text(
                      '(${playArea.playAreaLocation})',

                      style: TextStyle(fontSize: 12.0,),
                    ),
                  ],
                ),
                Icon(CupertinoIcons.add)
              ],



            ),
            SizedBox(height: 20,),
            Placeholder(fallbackHeight: 160,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(playArea.playAreaName, style: TextStyle(fontSize: 17.0)),
                SizedBox(width: 5.0),
                Text(
                  'Rs.${playArea.playAreaPrice}',

                  style: TextStyle(fontSize: 18.0,),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(onPressed:() {},
                      child: Text("Review1",style: TextStyle(fontSize: 10),),
                       ),
                    TextButton(onPressed:() {},
                        child: Text("Rating:4.5",style: TextStyle(fontSize: 10),)
                    ),

                  ],
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text("Book Now"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),

                ),

              ]
            )


          ],
        ),
        // child: Column(
        //   children: [
        //     Text(""),
        //     SizedBox(width: 16.0),
        //     Text(
        //       'Rs.${playArea.playAreaPrice.toStringAsFixed(2)}',
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
