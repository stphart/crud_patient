import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'App_Services/addpatient.dart';
import 'App_Services/editpatient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBWNWbmCjVFX1GEQel6LQ7F8cIL-gDGcs',
      appId: '1:418950512097:android:7b1fd64c0c6e67985166a0',
      messagingSenderId: '418950512097',
      projectId: 'demension-v1-database',
      databaseURL:
          'https://demension-v1-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    ),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen();
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String documentId = "";
  String patFName = '';
  String patLName = '';
  int patAge = 0;
  String patAddress = '';
  String patMedHistory = '';
  String patUserName = '';
  String patPassword = '';
  String patStatus = '';
  bool showPatientInfo = false;

  @override
  void initState() {
    super.initState();
    checkDocumentCount();
  }

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
        showPatientInfo = false;
      });
    }
  }

  showDeleteConfirmationDialog(BuildContext context, String documentID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                final CollectionReference collectionRef =
                    FirebaseFirestore.instance.collection('device').doc('31y1sQrytWv6r8gmNSwg').collection('admin').doc('Ardvn3AF3sEqkz1nC5Uc').collection('patient');

                await collectionRef.doc(documentID).delete().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Document deleted successfully'),
                  ));
                  Navigator.of(context).pop();
                  checkDocumentCount(); // Update data after delete
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error deleting document: $error'),
                  ));
                });
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToEditPatient() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPatientPage(
          patFName: patFName,
          patLName: patLName,
          patAge: patAge,
          patAddress: patAddress,
          patMedHistory: patMedHistory,
          patUserName: patUserName,
          patPassword: patPassword,
          patStatus: patStatus,
          documentID: documentId,
        ),
      ),
    );

    checkDocumentCount();

  }

  void navigateToAddPatient() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPatientPage(),
      ),
    );
    // Fetch updated data after adding
  checkDocumentCount();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient'),
        actions: [
          if (showPatientInfo)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                navigateToEditPatient();
              },
            ),
          if (showPatientInfo)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteConfirmationDialog(context, documentId);
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showPatientInfo)
              Column(
                children: [
                  Text('Patient Name: $patFName $patLName'),
                  Text('Age: $patAge'),
                  Text('Address: $patAddress'),
                  Text('Medical History: $patMedHistory'),
                  Text('Username: $patUserName'),
                  Text('Password: $patPassword'),
                  Text('Status: $patStatus'),
                ],
              ),
            if (!showPatientInfo)
              ElevatedButton(
                onPressed: () {
                  navigateToAddPatient();
                },
                child: Text('Add a Patient'),
              ),
          ],
        ),
      ),
    );
  }
}