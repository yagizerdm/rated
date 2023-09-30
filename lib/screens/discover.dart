import 'package:flutter/material.dart';
import 'package:rated/screens/genre_screen.dart';
import 'package:rated/screens/show_detail_screen.dart';
import '../models/genre_classification.dart';
import '../network/tvShow.dart';

class Discover extends StatefulWidget {
  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final pageMainColor = 0xffcb9b8c;
  final List<String> genres = [
    "Action", "Adventure", "Anime", "Comedy", "Crime",
    "Drama", "Espionage", "Family", "Fantasy", "History",
    "Horror", "Legal", "Medical", "Music", "Mystery", "Romance",
    "Science-Fiction", "Sports", "Supernatural", "Thriller", "War", "Western"
  ];

  List<TvShow> displayedShows = [];

  void runFilter(String enteredKeyword){
    List<TvShow> results = [];
    if(enteredKeyword.isEmpty || enteredKeyword.length < 3){
      results = [];
    } else{
      results = shows!
          .where((element) => element.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      displayedShows = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(pageMainColor)),
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(pageMainColor),
          appBar: AppBar(
            title: const Text('Discover',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            backgroundColor: Color(pageMainColor),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // search bar
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(40.0),
                  elevation: 10.0,
                  shadowColor: const Color(0xff5B8C5A),//0xff311B92
                  child: TextField(
                    onChanged: (value) => runFilter(value),
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: const Color(0xff5B8C5A),//0xff311B92
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff5B8C5A),
                        ),
                        hintText: 'Enter at least three characters',
                        hintStyle: const TextStyle(
                          color: Color(0xff5B8C5A),
                          fontSize: 14,
                        )
                    ),
                  ),
                ),
                displayedShows.isNotEmpty ?
                // search results
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: displayedShows.length > 15 ? 15 : displayedShows.length,
                  itemBuilder: (context, index){
                    final show = displayedShows[index];
                    return buildTvShow(show);
                  },
                )
                    :
                // genre boxes
                Card(
                  elevation: 5.0,
                  shadowColor: const Color(0xff5B8C5A),
                  margin: const EdgeInsets.all(7.0),
                  color: Color(pageMainColor),
                  child: Column(
                    children: [
                      Row(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 0.0),
                              child: const Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    text: "Genres",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      genreRowBuild(context, genres[0], genres[1], 0xff333B4F, 0xff3D4157),
                      genreRowBuild(context, genres[2], genres[3], 0xff4E5C6F, 0xff414761),
                      genreRowBuild(context, genres[4], genres[5], 0xff5A737A, 0xff4A1ABAE),
                      genreRowBuild(context, genres[6], genres[7], 0xff885256, 0xff6F555E),
                      genreRowBuild(context, genres[8], genres[9], 0xff855955, 0xffCF6F7A),
                      genreRowBuild(context, genres[10], genres[11], 0xffD0869D, 0xffF0ABAE),
                      genreRowBuild(context, genres[12], genres[13], 0xffB3879E, 0xffFABCB1),
                      genreRowBuild(context, genres[14], genres[15], 0xffe57373, 0xfff06292),
                      genreRowBuild(context, genres[16], genres[17], 0xffba68c8, 0xff9575cd),
                      genreRowBuild(context, genres[18], genres[19], 0xff7986cb, 0xff64b5f6),
                      genreRowBuild(context, genres[20], genres[21], 0xff4fc3f7, 0xff4dd0e1),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }



  Widget buildTvShow(TvShow tvShow){
    return InkWell(
      onTap: () {
        // TODO: Change root
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) =>
                ShowDetail(inputShow: tvShow),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          Container(
            margin: const EdgeInsets.all(5),
            height: 150,
            width: 102,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(tvShow.image!.original!),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 200, child: Text(tvShow.name?.toString() ?? 'TBA', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 8,),
                Text(tvShow.network?.name?.toString() ?? 'Netflix', style: const TextStyle(color: Colors.white60),),
                const SizedBox(height: 8,),
                Text(tvShow.rating?.average?.toString() ?? '7.5', style: const TextStyle(color: Colors.amber),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget genreRowBuild(BuildContext context, String genre1, String genre2, int color1, int color2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  GenreScreen(title: genre1)),
            );
          },
          child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              width: MediaQuery.of(context).size.width/2 - 21,
              decoration: BoxDecoration(
                color: Color(color1),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(7.0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.0),
                child: Text.rich(
                    TextSpan(
                      text: genre1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white
                      ),
                    )
                ),
              )
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  GenreScreen(title: genre2)),
            );
          },
          child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              width: MediaQuery.of(context).size.width/2 - 21,
              decoration: BoxDecoration(
                color: Color(color2),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(7.0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.0),
                child: Text.rich(
                    TextSpan(
                      text: genre2,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white
                      ),
                    )
                ),
              )
          ),
        )
      ],
    );
  }
}
