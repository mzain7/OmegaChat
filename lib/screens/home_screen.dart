import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appId = '593c423446144905984a284a824389e3';

  final token = '007eJxTYDh95ck5uYY5rdNLLydfUDBbEx8dtXf3tmmiZoc9X7FlBW1QYEg1TUm2MDVKMk1JNDWxNDW0MDEzMDIwMjQ2NjRLSk5KMt6uldoQyMiwwCiWhZEBAkF8Hoa0zKLiEueMxLy81BwGBgCgrCKC'; 

@override
  void initState() {
    super.initState();
    // initForAgora();
  }

  // Future<void> initForAgora(){}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        icon: const Icon(Icons.facebook),
        label: Text(FirebaseAuth.instance.currentUser!.email.toString()),
      ),
    );
  }
}
