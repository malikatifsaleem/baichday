import 'package:baichday/components/large_heading_widget.dart';
import 'package:baichday/constants/colors.dart';
import 'package:baichday/forms/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const screenId = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create an Account"),),
      backgroundColor: whiteColor,
      body: _body(),
    );
  }
}

_body() {
  return Padding(
    padding:const EdgeInsets.only(top: 10),
    child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 10),
        //   child: LargeHeadingWidget(
        //     heading: '',
        //     subHeading: 'Enter your Name, Email and Password for sign up.',
        //     anotherTaglineText: '\nAlready have an account ?',
        //     anotherTaglineColor: secondaryColor,
        //     subheadingTextSize: 16,
        //     taglineNavigation: true,
        //   ),
        // ),
        const RegisterForm(),
      ]),
    ),
  );
}
