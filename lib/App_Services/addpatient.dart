import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPatientPage extends StatefulWidget {
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  TextEditingController patFNameController = TextEditingController();
  TextEditingController patLNameController = TextEditingController();
  TextEditingController patAgeController = TextEditingController();
  TextEditingController patAddressController = TextEditingController();
  TextEditingController patMedHistoryController = TextEditingController();
  TextEditingController patUserNameController = TextEditingController();
  TextEditingController patPasswordController = TextEditingController();
  TextEditingController patStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: patFNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: patLNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: patAgeController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: patAddressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: patMedHistoryController,
              decoration: InputDecoration(labelText: 'Medical History'),
            ),
            TextFormField(
              controller: patUserNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: patPasswordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: patStatusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                savePatient();
              },
              child: Text('Save Patient'),
            ),
          ],
        ),
      ),
    );
  }

  void savePatient() {
    final fname = patFNameController.text;
    final lname = patLNameController.text;
    final age = int.parse(patAgeController.text);
    final address = patAddressController.text;
    final medHistory = patMedHistoryController.text;
    final username = patUserNameController.text;
    final password = patPasswordController.text;
    final status = patStatusController.text;
    final datecreated = DateTime.now();

    if (fname.isNotEmpty &&
        lname.isNotEmpty &&
        age != 0 &&
        address.isNotEmpty &&
        medHistory.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        status.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('device')
          .doc('31y1sQrytWv6r8gmNSwg')
          .collection('admin')
          .doc('Ardvn3AF3sEqkz1nC5Uc')
          .collection('patient')
          .add({
        'patFName': fname,
        'patLName': lname,
        'patAge': age,
        'patAddress': address,
        'patMedHistory': medHistory,
        'patUserName': username,
        'patPassword': password,
        'patStatus': status,
        'patDateCreated': datecreated,
      });

      patFNameController.clear();
      patLNameController.clear();
      patAgeController.clear();
      patAddressController.clear();
      patMedHistoryController.clear();
      patUserNameController.clear();
      patPasswordController.clear();
      patStatusController.clear();

      Navigator.of(context).pop();
    } else {
      // Handle empty input or display an error message.
    }
  }
}
