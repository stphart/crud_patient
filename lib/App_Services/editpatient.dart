import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPatientPage extends StatefulWidget {
  final String patFName;
  final String patLName;
  final int patAge;
  final String patAddress;
  final String patMedHistory;
  final String patUserName;
  final String patPassword;
  final String patStatus;
  final String documentID;

  EditPatientPage(
      {required this.patFName,
      required this.patLName,
      required this.patAge,
      required this.patAddress,
      required this.patMedHistory,
      required this.patUserName,
      required this.patPassword,
      required this.patStatus,
      required this.documentID});

  @override
  _EditPatientPageState createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  TextEditingController patFNameController = TextEditingController();
  TextEditingController patLNameController = TextEditingController();
  TextEditingController patAgeController = TextEditingController();
  TextEditingController patAddressController = TextEditingController();
  TextEditingController patMedHistoryController = TextEditingController();
  TextEditingController patUserNameController = TextEditingController();
  TextEditingController patPasswordController = TextEditingController();
  TextEditingController patStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the provided values
    patFNameController.text = widget.patFName;
    patLNameController.text = widget.patLName;
    patAgeController.text = widget.patAge.toString();
    patAddressController.text = widget.patAddress;
    patMedHistoryController.text = widget.patMedHistory;
    patUserNameController.text = widget.patUserName;
    patPasswordController.text = widget.patPassword;
    patStatusController.text = widget.patStatus;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Patient Information'),
      ),
      body: Column(
        children: [
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
          ElevatedButton(
            onPressed: () async {
              String editedFName = patFNameController.text;
              String editedLName = patLNameController.text;
              int editedAge = int.parse(patAgeController.text);
              String editedAddress = patAddressController.text;
              String editedMedHistory = patMedHistoryController.text;
              String editedUserName = patUserNameController.text;
              String editedPassword = patPasswordController.text;
              String editedStatus = patStatusController.text;

              final CollectionReference collectionRef = FirebaseFirestore
                  .instance
                  .collection('device')
                  .doc('31y1sQrytWv6r8gmNSwg')
                  .collection('admin')
                  .doc('Ardvn3AF3sEqkz1nC5Uc')
                  .collection('patient');
              final String documentID = widget.documentID;

              Map<String, dynamic> dataToUpdate = {
                'patFName': editedFName,
                'patLName': editedLName,
                'patAge': editedAge,
                'patAddress': editedAddress,
                'patMedHistory': editedMedHistory,
                'patUserName': editedUserName,
                'patPassword': editedPassword,
                'patStatus': editedStatus,
              };

              await collectionRef.doc(documentID).update(dataToUpdate).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Patient updated successfully'),
                ));
                Navigator.of(context).pop();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error updating patient: $error'),
                ));
              });
            },
            child: Text('Update'),
          ),
          
        ],
      ),
    );
  }
}
