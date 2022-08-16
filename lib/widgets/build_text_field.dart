import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    Key? key,
    required this.nameController,
    required this.textName,
    required this.giveHintText, required this.readOnly,  this.errorText,
  }) : super(key: key);

  final TextEditingController nameController;
  final String textName;
  final String giveHintText;
  final bool readOnly;
  final String? errorText;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0, right: 12),
            child: Text(
              textName,
              style: TextStyle(
                color: AppColors.textColor1,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          TextField(
            enabled: readOnly,
            controller: nameController,
            decoration: InputDecoration(
              errorText: errorText,
              hintText: giveHintText,
              //  border: InputBorder.none,
            ),
          ),
        ],
      );
}
