import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rated/models/genre_classification.dart';

class GenreSelection extends StatefulWidget {
  const GenreSelection({Key? key}) : super(key: key);

  @override
  State<GenreSelection> createState() => _GenreSelectionState();
}

class _GenreSelectionState extends State<GenreSelection> {
  final List<String> genres = [
    "Action", "Adventure", "Anime", "Comedy", "Crime",
    "Drama", "Espionage", "Family", "Fantasy", "History",
    "Horror", "Legal", "Medical", "Music", "Mystery", "Romance",
    "Science-Fiction", "Sports", "Supernatural", "Thriller", "War", "Western"
  ];

  HashSet selectedItem = HashSet();

  void select(String genre){
    setState(() {
      if(selectedItem.contains(genre)){
        selectedItem.remove(genre);
      } else{
        if(selectedItem.length<5){
          selectedItem.add(genre);
        }
      }
    });
  }

  Future addGenres(List<dynamic> selectedGenres) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'genre_list': selectedGenres,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffce4ec),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: (){Navigator.of(context).pop();},
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xff49599a),)
                  ),
                ),
                const SizedBox(height: 70,),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Select at most five genres',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff49599a)
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${selectedItem.length}/5',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff49599a)
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  height: 425,
                  child: Scrollbar(
                    thickness: 3,
                    thumbVisibility: true,
                    radius: const Radius.circular(20),
                    child: GridView.builder(
                      shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1.5
                        ),
                        itemCount: genres.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              select(genres[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff6f79a8).withOpacity(selectedItem.contains(genres[index]) ? 0.5 : 1),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                      child: Text(
                                        genres[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                  Visibility(
                                    visible: selectedItem.contains(genres[index]),
                                    child: const Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(Icons.check, size: 30, color: Colors.white,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width-100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xff6f79a8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MaterialButton(
                      elevation: 0,
                      onPressed: (){
                        addGenres(selectedItem.toList());
                        suggestedShows = [];
                        Navigator. of(context).pop();
                        },
                      color: const Color(0xff6f79a8),
                      child: const Text(
                        'Apply changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'San Francisco',
                          fontSize: 18,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
