import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dil_se_dil_takk/cards/profile.dart';
import 'package:dil_se_dil_takk/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:dil_se_dil_takk/main_page/blocked_passed.dart';
import 'package:dil_se_dil_takk/main_page/chat.dart';
import 'package:dil_se_dil_takk/main_page/like_nearby_online.dart';
import 'package:dil_se_dil_takk/main_page/main_page.dart';
import 'package:dil_se_dil_takk/model/usermodel.dart';
import 'package:dil_se_dil_takk/provider/declare.dart';

import '../dashboard/myprofile.dart';
class ChatUser extends StatelessWidget {
  UserModel user;

  ChatUser({required this.user});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(user: user)),
            );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height - 70,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(user.pic),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black26,
            ],
          ),
          borderRadius:
          BorderRadius.circular(20), // specify the border radius here
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height - 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black38,
              ],
            ),
            borderRadius: BorderRadius.circular(20), // specify the border radius here
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 9),
                child: Text(user.Name, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28),),
              ),
              hk(0, user.address),
              hk(1, calculateDistance(user.lat, user.lon, _user!.lat, _user.lon) + " km away"),
              hk(2, "Followers 0"),
              hk(3, "Following 0"),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
  Widget hk(int i, String hj){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          SizedBox(width: 11,),
          iconn(i),
          SizedBox(width: 9,),
          Text(hj, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
  Widget iconn( int j){
    if ( j == 0){
      return  Icon(Icons.location_pin, color :   Colors.white ,);
    }else if (j == 1){
      return Icon(Icons.directions_walk,color :  Colors.white ,);
    }else if ( j == 2){
      return Icon(Icons.people, color : Colors.white ,);
    }else{
      return Icon(Icons.follow_the_signs_sharp,color :  Colors.white ,);
    }
  }


  String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers

    // Convert latitude and longitude from degrees to radians
    final lat1Rad = _degreesToRadians(lat1);
    final lon1Rad = _degreesToRadians(lon1);
    final lat2Rad = _degreesToRadians(lat2);
    final lon2Rad = _degreesToRadians(lon2);

    // Calculate the differences between coordinates
    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    // Haversine formula
    final a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    final distance = R * c;

    // Format the distance as a string
    return distance.toStringAsFixed(0); // Adjust the precision as needed
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }


  String calculateW(double lat1, double lon1, double lat2, double lon2) {
    const walkingSpeed = 5.0; // Average walking speed in km/h

    double distance = calculateDistance1(lat1, lon1, lat2, lon2);
    // Calculate time in hours
    double time = distance * walkingSpeed;
    if( time  > 100 ){
      return "100+" ;
    }
    return time.toStringAsFixed(1);
  }
  String calculateC( double lat1, double lon1, double lat2, double lon2 , bool isHighway ) {
    // Set average car speeds based on the type of road
    double carSpeed = isHighway ? 100.0 : 40.0; // Adjust speeds as needed
    double distance = calculateDistance1(lat1, lon1, lat2, lon2);
    // Calculate time in hours
    double time = distance * carSpeed;

    return time.toStringAsFixed(1);
  }
  double calculateDistance1(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers

    // Convert latitude and longitude from degrees to radians
    final lat1Rad = _degreesToRadians(lat1);
    final lon1Rad = _degreesToRadians(lon1);
    final lat2Rad = _degreesToRadians(lat2);
    final lon2Rad = _degreesToRadians(lon2);

    // Calculate the differences between coordinates
    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    // Haversine formula
    final a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    final distance = R * c;

    // Format the distance as a string
    return distance ; // Adjust the precision as needed
  }
}