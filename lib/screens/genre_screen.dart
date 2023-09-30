import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rated/providers/watchlist_provider.dart';
import 'package:rated/screens/show_detail_screen.dart';
import '../models/genre_classification.dart';
import '../network/tvShow.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GenreScreen extends StatefulWidget {
  final String title;
  const GenreScreen({super.key, required this.title});
  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final pageMainColor = 0xffcb9b8c;
  late List<TvShow> specificShows;

  @override
  Widget build(BuildContext context) {

    specificShows = shows!.where((item) => item.genres!.contains(widget.title)).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Color(pageMainColor)),
      ),
      home: Scaffold(
        backgroundColor: Color(pageMainColor),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(pageMainColor),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: GridView.builder(
          itemCount: specificShows.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 68/100
          ),
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: fetchItem(context, index),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return snapshot.data as Widget;
                } else{
                  return Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.white,
                      size: 150
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<Widget> fetchItem(BuildContext context, int index) async{
    final firestoreService = Provider.of<AppState>(context).firestoreService;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ShowDetail(inputShow: specificShows[index]);
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
                  image: NetworkImage(specificShows[index].image!.original.toString()),
                )),
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async{
                if(await firestoreService.contains(specificShows[index])){
                  firestoreService.deleteDocument(specificShows[index].id!).then((value) => setState(() {}));
                } else{
                  firestoreService.addDocument(specificShows[index].toJson()).then((value) => setState(() {}));
                }
              },
              icon: Icon(
                (await firestoreService.contains(specificShows[index])) ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}