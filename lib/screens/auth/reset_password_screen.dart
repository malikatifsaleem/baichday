import 'package:baichday/components/large_heading_widget.dart';
import 'package:baichday/constants/colors.dart';
import 'package:baichday/forms/reset_form.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String screenId = 'reset_password_screen';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"),),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LargeHeadingWidget(
                  heading: '',
                  subHeading: 'Enter yout email to continue your password reset',
                  headingTextSize: 35,
                  subheadingTextSize: 20,
                ),
                ResetForm(),
              ]),
        ),
      ),
    );
  }
}
