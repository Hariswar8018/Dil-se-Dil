import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dil_se_dil_takk/cards/profile.dart';
import 'package:dil_se_dil_takk/global/drawer.dart';
import 'package:dil_se_dil_takk/model/usermodel.dart';

class Online extends StatelessWidget {
  bool likes ; bool nearby ;
  Online({super.key, required this.likes, required this.nearby});

  String f(){
    if(likes && nearby){
      return "Online";
    }else if(nearby){
      return "Nearby";
    }else if(likes){
      return "Likes";
    }else{
      return "Online";
    }
  }
  String yu = FirebaseAuth.instance.currentUser!.uid;
  List<UserModel> _list = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Crea
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Global.as(context),
      key: _key, // Assign the key to Scaffold.
      backgroundColor: Colors.white,
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
            child: Text(f(),
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Users').where("Like", arrayContains: yu).get(),
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

                        },
                        child: Text("Use Another City"),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                itemCount: _list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 5.0, // Space between columns
                  mainAxisSpacing: 5.0, // Space between rows
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatUserr(user: _list[index]),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
class ChatUserr extends StatelessWidget {
  UserModel user ;
  ChatUserr({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(user: user)),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 20,
        height: MediaQuery.of(context).size.width / 2 - 20,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(user.pic),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 20,
          height: MediaQuery.of(context).size.width / 2 - 20,
          decoration: BoxDecoration(

              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black38,
                ],
              ),
              borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.only( left :10.0, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Container(
                  width: MediaQuery.of(context).size.width  ,
                  height: 20,
                  child: Row(
                    children: [
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.circle, color : Colors.white, size: 8,),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Text(user.Name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.white, size: 20,),
                    Text(user.address, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),),
                  ],
                ),
                SizedBox(height: 7,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

