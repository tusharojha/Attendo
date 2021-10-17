import 'package:attendo/models/form_model.dart';
import 'package:attendo/models/regex.dart';
import 'package:attendo/providers/database_provider.dart';
import 'package:attendo/providers/user_data_provider.dart';
import 'package:attendo/utils/shared_preferences_fetcher.dart';
import 'package:attendo/widgets/custom_button.dart';
import 'package:attendo/widgets/custom_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormPage extends StatefulWidget {
  static const routeName = '/form';
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<TextEditingController> _controllers = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Form',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
          ),
          body: Consumer(builder: (context, watch, _) {
            final _database = watch(databaseProvider);

            void _onClick() async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final FormModel model = FormModel(
                name: _controllers[0].text,
                email: _controllers[1].text,
                enrollmentnumber: int.parse(_controllers[2].text),
                phonenumber: int.parse(_controllers[3].text),
              );
              context.read(currUserProvider).state = model;
              await SharedPreferencesFetcher.setEnrollmentNumber(
                  int.parse(_controllers[2].text));
              await _database.addUser(context, model);
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTileWidget(
                        controller: _controllers[0],
                        title: 'Full Name',
                        icon: Icons.person_outline_outlined,
                        inputType: TextInputType.text,
                        onChanged: (v) {
                          // if (v!.isValidName)
                          //   return null;
                          // else
                          //   return 'Please enter a Valid name';
                        },
                      ),
                      CustomTileWidget(
                        controller: _controllers[1],
                        title: 'College Email Address',
                        icon: Icons.mail_outline,
                        inputType: TextInputType.emailAddress,
                        onChanged: (v) {
                          if (v!.isValidEmail)
                            return null;
                          else
                            return 'Please enter a Valid Email';
                        },
                      ),
                      CustomTileWidget(
                        controller: _controllers[2],
                        title: 'Enrollment Number',
                        icon: Icons.school_rounded,
                        inputType: TextInputType.number,
                        onChanged: (v) {
                          // if (v!.isValidEnrollmentNumber)
                          //   return null;
                          // else
                          //   return 'Please enter a Valid Enrollment Number';
                        },
                      ),
                      CustomTileWidget(
                          controller: _controllers[3],
                          title: 'Phone Number',
                          icon: Icons.phone_android_outlined,
                          inputType: TextInputType.number,
                          onChanged: (v) {
                            // if (v!.isValidPhone)
                            //   return null;
                            // else
                            //   return 'Please enter a Valid Phone Number';
                          }),

                      // Spacer(),
                      CustomButton(onPressed: _onClick, text: 'Submit')
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
