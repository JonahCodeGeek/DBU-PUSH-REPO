import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/widgets/build_text_field.dart';
import 'package:flutter/material.dart';

class ElevatedButtons extends StatefulWidget {
  const ElevatedButtons({
    required this.label,
    required this.function,
    required this.buttonColor,
    required this.textColor,
  });
  final String label;
  final Function() function;
  final Color buttonColor;
  final Color textColor;
  @override
  State<ElevatedButtons> createState() => _ElevatedButtonsState();
}

class _ElevatedButtonsState extends State<ElevatedButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0.0),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          backgroundColor: MaterialStateProperty.all<Color>(widget.buttonColor),
        ),
        onPressed: widget.function,
        child: Text(
          widget.label,
          style: TextStyle(color: widget.textColor),
        ),
      ),
    );
  }
}

class BuildUserInfo extends StatelessWidget {
  const BuildUserInfo({Key? key, required this.nameController, required this.emailController, required this.phoneController, required this.bioController, required this.idController}) : super(key: key);
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final TextEditingController idController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        children: [
          BuildTextField(
            readOnly: false,
            nameController: nameController,
            textName: 'FullName',
            giveHintText: '',
          ),
          BuildTextField(
            readOnly: false,
            nameController: emailController,
            textName: 'Email',
            giveHintText: '',
          ),
          BuildTextField(
              nameController: phoneController,
              textName: 'Phone',
              giveHintText: '',
              readOnly: false),
          BuildTextField(
            readOnly: false,
            nameController: bioController,
            textName: 'Bio',
            giveHintText: '',
          ),
          BuildTextField(
            readOnly: false,
            nameController: idController,
            textName: 'Id',
            giveHintText: '',
          ),
        ],
      ),
    );
  }
}

Widget buildProfileBody(Function() handleUpdate, handleLogout) {
  return Center(
    child: Column(
      children: [
        SizedBox(height: 32),
        ElevatedButtons(
          label: 'Update Your Profile',
          function: handleUpdate,
          buttonColor: AppColors.primaryColor,
          textColor: Colors.white70,
        ),
        SizedBox(
          height: 30,
          child: Text(
            'Or',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Colors.grey,
                fontStyle: FontStyle.italic),
          ),
        ),
        ElevatedButtons(
          label: 'Logout',
          function: handleLogout,
          buttonColor: AppColors.scaffoldColor,
          textColor: Colors.red,
        ),
      ],
    ),
  );
}
