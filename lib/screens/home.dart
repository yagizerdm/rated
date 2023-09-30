import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rated/providers/watchlist_provider.dart';
import 'package:rated/screens/show_detail_screen.dart';
import 'dart:math';
import '../models/genre_classification.dart';
import '../models/remove_html_tags.dart';
import '../network/remote_service.dart';
import '../network/tvShow.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color pageMainColor = const Color(0xffcb9b8c);
  final Color largeCardColor = const Color(0xffffffee);
  final Color horizontalListColor = const Color(0xffffddc1);

  // 0, 74, 79, 81, 80, 21, 102, 106, 63, 60, 30, 294, 27, 258, 174, 124, 117, 454, 12, 10

  final randomIntegerList = [0, 74, 79, 81, 80, 21, 102, 106, 63, 60, 30, 294, 27, 258, 174, 124, 117, 454, 12, 10];

  Random random = Random.secure();

  late int firstRandomNumber;
  late int secondRandomNumber;
  late int thirdRandomNumber;
  late int firstRandomShow;
  late int secondRandomShow;
  late int thirdRandomShow;

  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    firstRandomNumber = Random().nextInt(18)+1;
    secondRandomNumber = firstRandomNumber-1;
    thirdRandomNumber = firstRandomNumber+1;
    firstRandomShow = randomIntegerList[firstRandomNumber];
    secondRandomShow = randomIntegerList[secondRandomNumber];
    thirdRandomShow = randomIntegerList[thirdRandomNumber];
    getData();
  }

  Future<List<dynamic>> getSelectedGenres() async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> selectedGenres = [];
    await FirebaseFirestore.instance.
    doc('/users/$uid').get().then((value) => selectedGenres = value.data()!['genre_list']);
    return selectedGenres;
  }

  getData() async {
    shows = await ZerothRemoteService().getShows();
    showsFirstPage = await FirstRemoteService().getShows();
    showsSecondPage = await SecondRemoteService().getShows();
    showsThirdPage = await ThirdRemoteService().getShows();
    showsEighthPage = await EigthRemoteService().getShows();

    if (shows != null && showsFirstPage != null && showsSecondPage != null && showsThirdPage != null && showsEighthPage != null) {
      shows!.addAll(showsFirstPage!);
      shows!.addAll(showsSecondPage!);
      shows!.addAll(showsThirdPage!);
      shows!.addAll(showsEighthPage!);

      Future<List<dynamic>> selectedGenres = getSelectedGenres();

      int length = await selectedGenres.then((list) => list.length);

      suggestedShows = [];

      for(int i=0; i<length; i++){
        dynamic element = await selectedGenres.then((list) => list[i]);
        suggestedShows.addAll(shows!.where((item) => item.genres!.contains(element)).toList());
      }

      if (suggestedShows.isNotEmpty) {
        shuffle(suggestedShows);
        if(suggestedShows.length>30){
          suggestedShows = suggestedShows.sublist(0, 30);
        }
      }

      highRatedShows = shows!.where((item) => (item.rating?.average ?? 7.5) > 8.5).toList();
      highRatedShows.sort((b, a) => a.rating!.average!.compareTo(b.rating!.average!));

      hboShows = shows!.where((item) => (item.network?.name ?? "Netflix") == "HBO").toList();

      nostalgiaShows = shows!.where((item) => (item.premiered?.year ?? 2013) < 2000).toList();
      shuffle(nostalgiaShows);
      if(nostalgiaShows.length>30){
        nostalgiaShows = nostalgiaShows.sublist(0, 30);
      }

      animatedCartoons = shows!.where((item) => (item.type ?? "Scripted") == "Animation").toList();
      if(animatedCartoons.length>30){
        animatedCartoons = animatedCartoons.sublist(0, 30);
      }
      shuffle(animatedCartoons);

      documentaryShows = shows!.where((item) => (item.type ?? "Scripted") == "Documentary").toList();
      documentaryShows = documentaryShows.where((item) => (item.rating?.average ?? 7.5) > 7.5).toList();
      documentaryShows.sort((b, a) => a.rating!.average!.compareTo(b.rating!.average!));
      if(documentaryShows.length>15){
        documentaryShows = documentaryShows.sublist(0, 15);
      }

      familyShows = shows!.where((item) => item.genres!.contains('Family')).toList();
      shuffle(familyShows);
      if(familyShows.length>15){
        familyShows = familyShows.sublist(0, 15);
      }

      comedyShows = shows!.where((item) => item.genres!.contains('Comedy')).toList();
      shuffle(comedyShows);
      if(comedyShows.length>15){
        comedyShows = comedyShows.sublist(0, 15);
      }

      romanceShows = shows!.where((item) => item.genres!.contains('Romance')).toList();
      shuffle(romanceShows);
      if(romanceShows.length>15){
        romanceShows = romanceShows.sublist(0, 15);
      }

      horrorShows = shows!.where((item) => item.genres!.contains('Horror')).toList();
      shuffle(horrorShows);
      if(horrorShows.length>15){
        horrorShows = horrorShows.sublist(0, 15);
      }

      setState(() {
        isLoaded = true;
      });
    }
  }

  Widget horizontalList(
      BuildContext context, String title, Color color, List<TvShow> inputList) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320.295),
                child: ListView.builder(
                  cacheExtent: 100,
                  itemExtent: 160,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: inputList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 320.295,
                      child: FutureBuilder(
                        future: fetchItem(context, color, inputList, index),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return snapshot.data as Widget;
                          }
                          // By default, show a loading spinner.
                          return Visibility(
                            visible: snapshot.connectionState == ConnectionState.waiting,
                            child: Container(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> fetchItem(BuildContext context, Color color, List<TvShow> inputList, int index)async{
    final firestoreService = Provider.of<AppState>(context).firestoreService;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ShowDetail(inputShow: inputList[index]);
        })).then((value) => setState(() {}));
      },
      child: Container(
        width: 160,
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 235.294117647,
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(inputList[index]
                            .image!
                            .original
                            .toString()),
                      )),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () async {
                      if (await firestoreService.contains(inputList[index])) {
                        firestoreService.deleteDocument(inputList[index].id!).then((value) => setState(() {}));
                      } else {
                        firestoreService.addDocument(inputList[index].toJson()).then((value) => setState(() {}));
                      }
                    },
                    icon: Icon(
                      (await firestoreService.contains(inputList[index]))
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
              const EdgeInsets.fromLTRB(1.0, 3.0, 5.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: Colors.green,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      TextSpan(
                        text: inputList[index].rating?.average?.toString() ?? '7.5',
                        style: const TextStyle(
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.fromLTRB(3.0, 1.0, 5.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  inputList[index].name?.toString() ?? 'TBA',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> largeCard(BuildContext context, Color color, int index) async {
    final firestoreService = Provider.of<AppState>(context).firestoreService;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ShowDetail(inputShow: shows![index]);
        })).then((value) => setState(() {}));
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(shows![index].image!.original!),
                  )),
            ),
            ListTile(
              title: Text(
                shows![index].name?.toString() ?? 'TBA',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () async {
                  if (await firestoreService.contains(shows![index])) {
                    firestoreService.deleteDocument(shows![index].id!).then((value) => setState(() {}));
                  } else {
                    firestoreService.addDocument(shows![index].toJson()).then((value) => setState(() {}));
                  }
                },
                icon: Icon(
                  (await firestoreService.contains(shows![index])) ?
                  Icons.favorite
                      :
                  Icons.favorite_outline,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 5.0, 5.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: Colors.green,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      TextSpan(
                        text: "${shows![index].rating?.average?.toString() ?? '7.5'} RATED",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: ReadMoreText(
                  RemoveHtml.stripHtmlIfNeeded(shows![index].summary?.toString() ?? 'No information'),
                  trimLines: 3,
                  textAlign: TextAlign.justify,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: "show more",
                  trimExpandedText: " show less",
                  lessStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  moreStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                    "${shows![index].premiered?.year ?? '2013'} • ${shows![index].status?.toString() ?? 'Ended'} | ${shows![index].network?.name?.toString() ?? 'Netflix'}",
                    textAlign: TextAlign.left),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: pageMainColor),
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: pageMainColor,
          appBar: AppBar(
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            backgroundColor: pageMainColor,
          ),
          body: isLoaded
              ? SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: largeCard(context, largeCardColor, (firstRandomShow)),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return snapshot.data as Widget;
                      } else{
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
                          width: double.infinity,
                          child: Center(
                            child: LoadingAnimationWidget.newtonCradle(
                                color: Colors.white,
                                size: 150
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Visibility(
                    visible: suggestedShows.isNotEmpty,
                    child: horizontalList(context, 'Similar to what you like',
                        horizontalListColor, suggestedShows),
                  ),
                  Visibility(
                    visible: suggestedShows.isEmpty,
                    child: Card(
                        color: horizontalListColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                          child: Text(
                            "Go set your favourite genres in profile screen to see suggested series!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        )
                    ),
                  ),
                  horizontalList(context, 'Rated 8.5+',
                      horizontalListColor, highRatedShows),
                  horizontalList(context, 'From HBO',
                      horizontalListColor, hboShows),//0xffede7f6
                  FutureBuilder(
                    future: largeCard(context, largeCardColor, (secondRandomShow)),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return snapshot.data as Widget;
                      } else{
                        return const Text('');
                      }
                    },
                  ),
                  horizontalList(context, 'Good old days',
                      horizontalListColor, nostalgiaShows),
                  horizontalList(context, 'Animated adventures',
                      horizontalListColor, animatedCartoons),
                  horizontalList(context, 'Documentaries',
                      horizontalListColor, documentaryShows),
                  FutureBuilder(
                    future: largeCard(context, largeCardColor, (thirdRandomShow)),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return snapshot.data as Widget;
                      } else{
                        return const Text('');
                      }
                    },
                  ),
                  horizontalList(context, 'Family matters',
                      horizontalListColor, familyShows),
                  horizontalList(context, 'Couples corner',
                      horizontalListColor, romanceShows),
                  horizontalList(context, 'Thrills and chills',
                      horizontalListColor, horrorShows),
                  horizontalList(context, 'Jokes on jokes',
                      horizontalListColor, comedyShows),
                ],
              ))
              : Center(
                  child: LoadingAnimationWidget.newtonCradle(
                  color: Colors.white,
                  size: 150
                ),
              ),
      ),
    );
  }
}
