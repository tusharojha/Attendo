import 'package:attendo/models/class_model.dart';
import 'package:attendo/models/form_model.dart';
import 'package:attendo/pages/home_screen.dart';
import 'package:attendo/utils/shared_preferences_fetcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final FirebaseFirestore firestore;

  FirestoreDatabase(this.firestore);

  Future<void> addUser(BuildContext context, FormModel data) async {
    final student = firestore.collection('students').withConverter<FormModel>(
          fromFirestore: (snapshot, _) => FormModel.fromMap(snapshot.data()!),
          toFirestore: (data, _) => data.toMap(),
        );
    try {
      student.doc(data.enrollmentnumber.toString()).set(data);
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } on FirebaseException catch (e) {
      print(e);
      //  Show a dialog box with the error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something went wrong'),
              content: Text(e.message as String),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<FormModel?> getCurrentUser() async {
    final int enrollmentNumber =
        await SharedPreferencesFetcher.getEnrollmentNumber();
    print(enrollmentNumber);
    try {
      final docs = await FirebaseFirestore.instance
          .collection('students')
          .doc(enrollmentNumber.toString())
          .withConverter<FormModel>(
            fromFirestore: (snapshot, _) => FormModel.fromMap(snapshot.data()!),
            toFirestore: (data, _) => data.toMap(),
          )
          .get();
      return docs.data();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<List<QueryDocumentSnapshot<ClassModel>>?> getClasses() async {
    final collections = firestore
        .collection('classes')
        .withConverter<ClassModel>(
            fromFirestore: (snapshots, _) =>
                ClassModel.fromMap(snapshots.data()!),
            toFirestore: (model, _) => model.toMap());
    // .get();
    try {
      // final List<QueryDocumentSnapshot<ClassModel>> list = collections.docs;
      final liveList = await collections.where('live', isEqualTo: true).get();

      // final temp = pastList.docs;
      // print(temp);
      return liveList.docs;
    } on FirebaseFirestore catch (e) {
      print(e);
    }
  }

  Future<List<QueryDocumentSnapshot<ClassModel>>?> getOldClasses() async {
    final collections = firestore
        .collection('classes')
        .withConverter<ClassModel>(
            fromFirestore: (snapshots, _) =>
                ClassModel.fromMap(snapshots.data()!),
            toFirestore: (model, _) => model.toMap());
    // .get();
    try {
      // final List<QueryDocumentSnapshot<ClassModel>> list = collections.docs;

      final pastList = await collections.where('live', isEqualTo: false).get();
      // final temp = pastList.docs;
      // print(temp);
      return pastList.docs;
    } on FirebaseFirestore catch (e) {
      print(e);
    }
  }
}
