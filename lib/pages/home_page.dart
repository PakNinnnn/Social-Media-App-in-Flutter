import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_drawer.dart';
import 'package:social_media_app/components/my_post_button.dart';
import 'package:social_media_app/components/my_textfield.dart';
import 'package:social_media_app/database/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController newPostController = TextEditingController();

  final FirestoreDatabase db = FirestoreDatabase();

  bool liked = false; 

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      db.addPost(newPostController.text);
    }

    //clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('H O M E'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          //Logout button
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: "Say Something...",
                      obscureText: false,
                      controller: newPostController),
                ),
                const SizedBox(width: 10),
                MyPostButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),

          //Post
          StreamBuilder(
            stream: db.getPost(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts... Post something"),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      //Get individual post
                      final post = posts[index];
                      //get data from each post
                      String message = post['message'];
                      String userEmail = post['email'];
                      Timestamp timestamp = post['timestamp'];

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(156, 122, 122, 122)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                ListTile(
                                  title: Text(message),
                                  subtitle: Text(
                                    userEmail,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: IconButton(
                                    icon: liked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                                    onPressed: () {
                                      setState(() {
                                        liked = !liked;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
