import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rated/network/tvShow.dart';
import 'package:rated/providers/watchlist_provider.dart';
import 'package:rated/screens/show_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Watchlist extends StatefulWidget {
  Watchlist({super.key});
  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {

  Future<List<TvShow>> getDocsInWatchlist(BuildContext context) async{
    List<TvShow> snapshotList = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference container = FirebaseFirestore.instance.collection('/users/$uid/watchlist');
    QuerySnapshot snapshot = await container.get();
    snapshot.docs.forEach((document) {
      snapshotList.add(TvShow.fromJson(document.data() as Map<String, dynamic>));
    });
    return snapshotList;
  }

  final pageMainColor = 0xffcb9b8c;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<AppState>(context).firestoreService;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Color(pageMainColor)),
      ),
      home: Scaffold(
        backgroundColor: Color(pageMainColor),
        appBar: AppBar(
          title: const Text(
            'Watchlist',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(pageMainColor),
        ),
        body: FutureBuilder(
          future: getDocsInWatchlist(context),
          builder: (context, AsyncSnapshot<List<TvShow>> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isEmpty){
                return Center(child: Image.asset('assets/images/empty_watchlist.png'));
              } else{
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 68/100
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ShowDetail(inputShow: snapshot.data![index]);
                        })).then((value) => setState(() {}));
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            height: 382.352941176,
                            width: 260,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(snapshot.data![index].image!.original.toString()),
                                )),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () async{
                                firestoreService.deleteDocument(snapshot.data![index].id!).then((value) => setState(() {}));
                              },
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else{
              return Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white,
                    size: 150
                ),
              );
            }
          },
        ),
      )
    );
  }
}