
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const DrawerHeader(
                    child: Icon(
                      Icons.favorite_border,
                      size: 50, 
                    ),
                  ),
                  
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    leading: const Icon(Icons.home),
                    title: const Text("H O M E"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    leading: const Icon(Icons.account_box),
                    title: const Text("P R O F I L E"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile_page');
                    },
                  ),

                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    leading: const Icon(Icons.people_sharp),
                    title: const Text("U S E R S"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/users_page');},
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  leading: const Icon(Icons.logout),
                  title: const Text("L O G O U T"),
                  onTap: () => FirebaseAuth.instance.signOut(),
                ),
              )
            ],
          ),
        ));
  }
}
