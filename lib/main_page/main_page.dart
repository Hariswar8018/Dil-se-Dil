import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:dil_se_dil_takk/cards/homecard.dart';
import 'package:dil_se_dil_takk/cards/meessagecard.dart';
import 'package:dil_se_dil_takk/dashboard/myprofile.dart';
import 'package:dil_se_dil_takk/global/drawer.dart';
import 'package:dil_se_dil_takk/main_page/blocked_passed.dart';
import 'package:dil_se_dil_takk/main_page/like_nearby_online.dart';
import 'package:dil_se_dil_takk/provider/declare.dart';

import '../model/usermodel.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }
  void initState(){
    vq();
    super.initState();
    vq();
  }




  int indexx = 0 ;

  List<UserModel> _list = [];
  final CardSwiperController controller = CardSwiperController();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key, // Assign the key to Scaffold.
      backgroundColor: Colors.white,
      drawer: Global.as(context),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Icon(Icons.menu, color: Colors.black),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xffE9075B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 35, right: 35, top: 9, bottom: 9),
            child: Text("Explore",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              // Navigate to the new page with the selected user
              if (_list.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(user: _list.elementAt(indexx)),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: Icon(Icons.filter_list_alt, color: Colors.black),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('Users').get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                    if (_list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                                "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/33843/woman-girl-smartphone-clipart-md.png",
                                height: 150),
                            Text("Sorry, No one's in Your City",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600)),
                            Text(
                                "Why don't you Share your App to your Friends",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Share App now >>"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text("Use Another City"),
                            ),
                          ],
                        ),
                      );
                    }
                    return CardSwiper(
                      cardsCount: _list.length,
                      numberOfCardsDisplayed:  _list.length ,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      controller: controller,
                      cardBuilder: (context, index, percentThresholdX,
                          percentThresholdY) {
                        return Container(
                          child: ChatUser(user: _list[index]),
                        );
                      },
                    );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      controller.undo;
                      setState((){

                      });
                    },
                    icon: Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () async {
                      String g = FirebaseAuth.instance.currentUser!.uid ;
                      // Navigate to the new page with the selected user
                      await FirebaseFirestore.instance.collection("Users").doc(_list[indexx].uid).update(
                          {
                            "Like": FieldValue.arrayUnion([g]),
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text( "User added to your Like Section"),
                        ),
                      );
                    },
                    icon: Icon(Icons.favorite, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      if (_list.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(user: _list.elementAt(indexx)),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.chat, color: Colors.white),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      controller.swipe(CardSwiperDirection.left);
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    if( indexx >= _list.length-1){
      indexx = 0 ;
    }else{
      indexx = indexx +  1 ;
    }


    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
      ) {
    indexx = 0;
    setState((){

    });
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}


