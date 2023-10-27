import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckAndDisplayDocument extends StatefulWidget {
  @override
  _CheckAndDisplayDocumentState createState() => _CheckAndDisplayDocumentState();
}

class _CheckAndDisplayDocumentState extends State<CheckAndDisplayDocument> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String? documentId;
    String? patFName;
    String? patLName;
    int? patAge;
    String? patAddress;
    String? patMedHistory;
    String? patUserName;
    String? patPassword;
    String? patStatus;
  bool showPatientInfo = false; // Add this flag

  @override
  void initState() {
    super.initState();
    checkDocumentCount();
  }

  // Function to check the number of documents in a sub-collection
  Future<void> checkDocumentCount() async {
    QuerySnapshot querySnapshot = await _firestore
       .collection('device')
      .doc('31y1sQrytWv6r8gmNSwg')
      .collection('admin')
      .doc('Ardvn3AF3sEqkz1nC5Uc')
      .collection('patient')
        .get();

      if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs[0].data() as Map<String, dynamic>;
      setState(() {
        documentId = querySnapshot.docs[0].id;
        patFName = data['patFName'];
        patLName = data['patLName'];
        patAge = data['patAge'];
        patAddress = data['patAddress'];
        patMedHistory = data['patMedHistory'];
        patUserName = data['patUserName'];
        patPassword = data['patPassword'];
        patStatus = data['patStatus'];
        showPatientInfo = true;
      });
    } else {
      setState(() {
        showPatientInfo = false; // Set the flag to false if no documents are found
      });
    }
  }

  // Function to add a new document to the sub-collection
  Future<void> addNewDocument() async {
    await _firestore
        .collection('device')
          .doc('31y1sQrytWv6r8gmNSwg')
          .collection('admin')
          .doc('Ardvn3AF3sEqkz1nC5Uc')
          .collection('patient') // Replace with your sub-collection name
        .add({
      'patFName': "fname",
        'patLName': "lname",
        'patAge': "age",
        'patAddress': "address",
        'patMedHistory': "med history",
        'patUserName': "username",
        'patPassword': "password",
        'patStatus': "status", 
        'pateDateCreated' : "datecreated"
      // Add your fields and values here
    });

    // After adding a new document, you might want to refresh the UI
    checkDocumentCount();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Check and Display Document'),
      actions: [
        if (showPatientInfo) // Show buttons if patient information is displayed
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle Edit button press
              // You can navigate to the edit screen here
            },
          ),
        if (showPatientInfo) // Show buttons if patient information is displayed
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Handle Delete button press
              // You can delete the document here
            },
          ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showPatientInfo) // Show patient information if the flag is true
            Column(
              children: [
                Text('Patient Name: $patFName $patLName'),
                Text('Age: $patAge'),
                Text('Address: $patAddress'),
                Text('Medical History: $patMedHistory'),
                Text('Username: $patUserName'),
                Text('Password: $patPassword'),
                Text('Status: $patStatus'),
                // Display patient information here
                // Use Text widgets to display patFName, patLName, patAge, etc.
              ],
            ),
          if (!showPatientInfo)
            ElevatedButton(
              onPressed: () {
                addNewDocument();
              },
              child: Text('Add a New Document'),
            ),
        ],
      ),
    ),
  );
}

}