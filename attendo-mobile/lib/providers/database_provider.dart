import 'package:attendo/models/class_model.dart';
import 'package:attendo/providers/firebaseProviders.dart';
import 'package:attendo/utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<FirestoreDatabase>((ref) {
  return FirestoreDatabase(ref.watch(firestoreDatabaseProvider));
});

final liveClassesProvider =
    FutureProvider<List<QueryDocumentSnapshot<ClassModel>>?>((ref) async {
  return await ref.read(databaseProvider).getClasses();
});
final pastClassesProvider =
    FutureProvider<List<QueryDocumentSnapshot<ClassModel>>?>((ref) async {
  return await ref.read(databaseProvider).getOldClasses();
});
