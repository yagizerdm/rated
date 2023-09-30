import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rated/screens/genre_selection_screen.dart';
import 'auth_screens/forgot_pass_screen.dart';

class Profile extends StatefulWidget {

  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Color pageMainColor = const Color(0xffcb9b8c);

//0xff006064
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getUserName(String uid) async{
    String userName = 'An error occurred';
    await FirebaseFirestore.instance.
      doc('/users/$uid').get().then((value) => userName = value.data()!['first name']);
    return userName;
  }

  Future<List<dynamic>> getUserGenres(String uid) async{
    List<dynamic> userGenres = [];
    await FirebaseFirestore.instance.
    doc('/users/$uid').get().then((value) => userGenres = value.data()!['genre_list']);
    return userGenres;
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: pageMainColor),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: pageMainColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40,),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Icon(Icons.person, size: 90, color: pageMainColor,),
                  ),
                  const SizedBox(height: 40,),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.white,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: FutureBuilder(
                              future: getUserName(uid),
                              builder: (context, AsyncSnapshot<String> snapshot){
                                if(snapshot.hasError){
                                  return Text('Error: ${snapshot.error}');
                                }
                                switch(snapshot.connectionState){
                                  case ConnectionState.waiting:
                                    return const Text('Loading...');
                                  default:
                                    return Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.grey
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              FirebaseAuth.instance.currentUser?.email?.toString() ?? 'An error occurred',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text(
                            'Favourite Genres',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: FutureBuilder(
                              future: getUserGenres(uid),
                              builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                                if(snapshot.hasError){
                                  return Text('Error: ${snapshot.error}');
                                }
                                switch(snapshot.connectionState){
                                  case ConnectionState.waiting:
                                    return const Text('Loading...');
                                  default:
                                    return Text(
                                      snapshot.data!.isNotEmpty ?
                                      snapshot.data!.toString().substring(1, snapshot.data!.toString().length-1)
                                      :
                                      'You haven\'t set your favourite genres',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.grey
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Divider(
                            color: Colors.grey, //color of divider
                            height: 5, //height spacing of divider
                            thickness: 1,//spacing at the end of divider
                            indent: 10,
                            endIndent: 10,
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: pageMainColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: MaterialButton(
                                elevation: 0,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return const GenreSelection();
                                  })).then((value) => setState(() {}));
                                },
                                color: pageMainColor,
                                child: const Text(
                                  'Set your favourite genres',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'San Francisco',
                                    fontSize: 18,
                                  ),
                                )
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: pageMainColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: MaterialButton(
                                elevation: 0,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return const ForgotPasswordScreen();
                                  }));
                                },
                                color: pageMainColor,
                                child: const Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'San Francisco',
                                    fontSize: 18,
                                  ),
                                )
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: pageMainColor),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: MaterialButton(
                                elevation: 0,
                                onPressed: (){_signOut();},
                                color: Colors.white,
                                child: Text.rich(
                                  TextSpan(
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: "Sign out  ",
                                        style: TextStyle(
                                          color: pageMainColor,
                                          fontFamily: 'San Francisco',
                                          fontSize: 18,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.logout,
                                          color: pageMainColor,
                                        ),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}