import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omega_chat/utils/firebase.dart';
import 'package:omega_chat/widgets/image_input.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewUser extends StatefulWidget {
  const NewUser({super.key, required this.newUser});

  final bool newUser;

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  DateTime? _selectedDate;
  final _form = GlobalKey<FormState>();
  final _genderController = TextEditingController();
  final _countryController = TextEditingController();
  List<String>? countries;
  XFile? image;
  String name = '';
  String photoUrl = '';

  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    name =
        widget.newUser ? '' : FirebaseAuth.instance.currentUser!.displayName!;
    photoUrl = widget.newUser
        ? 'https://firebasestorage.googleapis.com/v0/b/omega-chat-fd459.appspot.com/o/user_pictures%2Fuser%20logo.jpg?alt=media&token=7bc4bcff-214f-4651-9110-02e70ae84722&_gl=1*1ha5zh0*_ga*OTg3NDkyMTQxLjE2OTY2ODQ4NjY.*_ga_CW55HF8NVT*MTY5NzM2MDU4OS4yOS4xLjE2OTczNjA3MTAuMS4wLjA.'
        : FirebaseAuth.instance.currentUser!.photoURL!;
    super.initState();
    fetchCountries().then((value) {
      setState(() {
        countries = value;
      });
    });
    if (!widget.newUser) {
      getUserDetails(FirebaseAuth.instance.currentUser!.uid).then((value) {
        setState(() {
          userDetails = value;
          print(value);
          _selectedDate =
              value?['dob'] != null ? DateTime.parse(value?['dob']) : null;
        });
      });
    }
  }

  @override
  void dispose() {
    _genderController.dispose();
    _countryController.dispose();
    countries = null;
    super.dispose();
  }

  void setImage(XFile img) {
    image = img;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: userDetails?['dob'] == null
          ? DateTime(now.year - 20, now.month, now.day)
          : DateTime.parse(userDetails?['dob']!),
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<List<String>> fetchCountries() async {
    final res =
        await http.get(Uri.parse('https://api.first.org/data/v1/countries'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['data'] as Map<String, dynamic>;
      var countries = data.values.toList();
      return countries.map((e) => e['country'] as String).toList();
    } else {
      return ['Error Occur'];
    }
  }

  void _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    if (image != null) {
      // widget.photoUrl = await uploadImageToFirebase(image!);
      photoUrl = image!.path;
    }
    print({
      "name": name,
      "photoUrl": photoUrl,
      "gender": _genderController.text,
      "country": _countryController.text,
      "dob": _selectedDate.toString(),
    });
    Navigator.of(context).pop({
      "name": name,
      "photoUrl": photoUrl,
      "gender": _genderController.text,
      "country": _countryController.text,
      "dob": _selectedDate.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    print("New User Screen");
    _genderController.text = userDetails?['gender'] ?? '';
    _countryController.text = userDetails?['country'] ?? '';
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              key: _form,
              child: TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || value.toString().trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.length < 4) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
            ),
            ImageInput(setImage: setImage, imageUrl: photoUrl),
            ElevatedButton(onPressed: _submit, child: const Text('Next')),
            ElevatedButton.icon(
              onPressed: _presentDatePicker,
              icon: const Icon(
                Icons.calendar_month,
              ),
              label: Text(_selectedDate == null
                      ? 'Date of Birth: --/--/----'
                      : 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  // : formatter.format(_selectedDate!),
                  ),
            ),
            CustomDropdown(
              hintText: 'Select a Gender',
              items: const ['Male', 'Female', 'Shhh! Asi batay bati nahi jati'],
              controller: _genderController,
            ),
            CustomDropdown.search(
              hintText: 'Select your Country',
              items: countries ?? ['Loading...'],
              controller: _countryController,
            ),
          ],
        ),
      ),
    );
  }
}

Route createRoute(bool isNewUser) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewUser(
      newUser: isNewUser,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
