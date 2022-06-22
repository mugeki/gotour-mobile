import 'package:flutter/material.dart';
import 'package:gotour_mobile/screens/my_place.dart';
import 'package:gotour_mobile/services/places.dart';

class EditPlaceForm extends StatefulWidget {
  @override
  EditPlaceFormState createState() {
    return EditPlaceFormState();
  }
}

class EditPlaceFormState extends State<EditPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response =
          await postPlace(nameCtrl.text, locationCtrl.text, descCtrl.text);
      print('response code: ${response.meta.code}');
      if (response.meta.code == 200) {
        Navigator.pop(
          context,
          // MaterialPageRoute(builder: (context) => const MyPlaces()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Place Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: locationCtrl,
              decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              // pEditing:
              child: const Text(
                'Edit Place',
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
