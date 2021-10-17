// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:attendo/models/form_model.dart';
import 'package:attendo/providers/auth_provider.dart';
import 'package:attendo/providers/database_provider.dart';
import 'package:attendo/providers/user_data_provider.dart';

import 'scanner_screen.dart';

class HomePage extends ConsumerWidget {
  static const String routeName = '/home';

  HomePage({Key? key}) : super(key: key);

  List<ClassTileWidget> _liveClasses = [];
  List<ClassTileWidget> _pastClasses = [];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //  Second variable to access the Logout Function
    final _auth = watch(authenticationProvider);
    final _user = watch(userProvider);
    FormModel? _userData = watch(currUserProvider).state;
    final _classesLive = watch(liveClassesProvider);
    final _classesPast = watch(pastClassesProvider);

    _user.whenData((data) => _userData = data);

    _classesPast.whenData((value) {
      value?.forEach((element) {
        final id = element.id;
        final model = element.data();
        bool attended = false;
        model.attendees.forEach((key, value) {
          if (model.attendees[key]['studentEnr'] ==
              _userData!.enrollmentnumber.toString()) {
            attended = true;
          }
        });
        _pastClasses.add(ClassTileWidget(
          name: model.name,
          live: model.live,
          date: model.createdOn,
          id: id,
          enrollment: _userData!.enrollmentnumber.toString(),
          stuName: _userData!.name,
          isAttended: attended,
        ));
      });
    });

    _classesLive.whenData((value) {
      value?.forEach((element) {
        final id = element.id;
        final model = element.data();
        bool attended = false;
        model.attendees.forEach((key, value) {
          if (model.attendees[key]['studentEnr'] ==
              _userData!.enrollmentnumber.toString()) {
            attended = true;
          }
        });
        _liveClasses.add(ClassTileWidget(
          name: model.name,
          live: model.live,
          date: model.createdOn,
          id: id,
          enrollment: _userData!.enrollmentnumber.toString(),
          stuName: _userData!.name,
          isAttended: attended,
        ));
      });
    });

    print(_liveClasses.length);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Tooltip(
            message: 'Logout',
            child: IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: FaIcon(FontAwesomeIcons.doorOpen),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome, ${_userData?.name}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            if (_liveClasses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Live Classes',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ..._liveClasses,
            if (_pastClasses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Past Classes',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ..._pastClasses,
          ],
        ),
      )),
    );
  }
}

class ClassTileWidget extends ConsumerWidget {
  final String name;
  bool live = false;
  final Timestamp date;
  final String id;
  final String enrollment;
  final String stuName;
  final bool isAttended;

  ClassTileWidget({
    Key? key,
    required this.name,
    required this.live,
    required this.date,
    required this.id,
    required this.enrollment,
    required this.stuName,
    required this.isAttended,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: live ? Colors.green : Colors.red,
        radius: 14,
      ),
      title: Text(name),
      subtitle: Text(
          '${DateFormat('yyyy-MM-dd – kk:mm').format(date.toDate())}'),
      trailing: isAttended
          ? Icon(
              Icons.check,
              color: Colors.green,
            )
          : live
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScannerScreen(
                        enrollNo: enrollment,
                        name: stuName,
                        classId: id,
                      ),
                    ));
                  },
                  icon: Icon(Icons.qr_code_scanner),
                )
              : Icon(Icons.cancel, color: Colors.red),
    );
  }
}
