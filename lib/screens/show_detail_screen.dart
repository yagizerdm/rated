import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rated/models/remove_html_tags.dart';
import '../network/tvShow.dart';
import 'package:provider/provider.dart';
import 'package:rated/providers/watchlist_provider.dart';

class ShowDetail extends StatefulWidget {
  final TvShow inputShow;
  const ShowDetail({Key? key, required this.inputShow}) : super(key: key);

  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  static const tileBackColor = Color(0xffffffff);
  static const tileTextColor = Color(0xffba6b6c);
  late TvShow inputShow;

  String genreToString(List<String> genres) {
    String ans = "";
    for (String genre in genres) {
      ans += "$genre\n";
    }

    if(ans.isNotEmpty){
      return ans.substring(0, ans.length-1);
    } else{
      return 'Adventure';
    }
  }

  @override
  void initState() {
    inputShow = widget.inputShow;
    super.initState();
  }

  Future<Widget> displayScreen(BuildContext context) async{
    final firestoreService = Provider.of<AppState>(context).firestoreService;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: tileTextColor),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xffcb9b8c),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {Navigator.pop(context);},
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            inputShow.name?.toString() ?? 'TBA',
            style: const TextStyle(
                fontSize: 24,
                color: Colors.white
            ),
          ),
          backgroundColor: const Color(0xffcb9b8c),
          actions: [
            IconButton(
              onPressed: () async {
                if (await firestoreService.contains(inputShow)) {
                  firestoreService.deleteDocument(inputShow.id!).then((value) => setState(() {}));
                } else {
                  firestoreService.addDocument(inputShow.toJson()).then((value) => setState(() {}));
                }
              },
              icon: Icon(
                (await firestoreService.contains(inputShow)) ?
                Icons.favorite
                    :
                Icons.favorite_outline,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: tileBackColor,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: tileTextColor)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: (MediaQuery.of(context).size.width-32)*1.470588235,
                      width: MediaQuery.of(context).size.width-32,//260,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: tileTextColor,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(inputShow.image!.original.toString()),
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Divider(
                  color: tileTextColor, //color of divider
                  height: 5, //height spacing of divider
                  thickness: 1.5, //thickness of divider line
                  indent: 25, //spacing at the start of divider
                  endIndent: 25, //spacing at the end of divider
                ),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: tileBackColor,
                    border: Border.all(
                      color: tileTextColor,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                      child: Center(
                        child: Text(
                          inputShow.name?.toString() ?? 'TBA',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: tileTextColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Rating:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.rating?.average?.toString() ?? '7.5',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Platform:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.network?.name?.toString() ?? 'Netflix',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Type:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.type?.toString() ?? 'Scripted',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Language:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.language?.toString() ?? 'English',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: tileBackColor,
                      border: Border.all(
                        color: tileTextColor,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Genres:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: tileTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            genreToString(inputShow.genres ?? []),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 17,
                              color: tileTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Genres:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    genreToString(inputShow.genres ?? []),
                    //inputShow.genres!.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                )
                 */
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Status:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.status?.toString() ?? 'Ended',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Premiered in:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.premiered?.year.toString() ?? '2013',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: tileBackColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: tileTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Country:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                  trailing: Text(
                    inputShow.network?.country?.name?.toString() ?? 'United States',
                    style: const TextStyle(
                      fontSize: 17,
                      color: tileTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Container(
                  decoration: BoxDecoration(
                      color: tileBackColor,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: tileTextColor)
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Center(
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: tileTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          RemoveHtml.stripHtmlIfNeeded(inputShow.summary?.toString() ?? 'No information'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: tileTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: displayScreen(context),
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
  }
}
