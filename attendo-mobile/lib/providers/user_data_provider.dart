import 'package:attendo/models/form_model.dart';
import 'package:attendo/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currUserProvider = StateProvider<FormModel?>((ref) {
  return null;
});

final userProvider = FutureProvider<FormModel?>((ref) async {
  return await ref.read(databaseProvider).getCurrentUser();
});
