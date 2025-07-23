import 'package:flutter/material.dart';

class DropdownHour extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onSelected;
  final List<String> timeOptions;

  const DropdownHour({
    required this.controller,
    required this.hintText,
    required this.onSelected,
    required this.timeOptions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownEntries = timeOptions
      .map((time) => DropdownMenuEntry<String>(
        value: time,
        label: '',
        labelWidget: Center(
          child: Text(
            time,
            style: TextStyle(
              color: Color(0xff2F2F2F),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )).toList();
      
      return DropdownMenu<String>(
      initialSelection: controller.text.isNotEmpty
      ? controller.text
      : timeOptions.first,
      label: Text(
        hintText,
        style: TextStyle(
          color: Color(0xff838383),
          fontSize: 20,
        ),
      ),
      trailingIcon: const Icon(
        Icons.arrow_drop_down,
        color: Color(0xff838383),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffB0B0B0)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffB0B0B0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffB0B0B0)),
        ),
      ),
      menuHeight: 200,
      onSelected: (String? value){
        if (value != null) {
          controller.text = value;
          onSelected(value);
        }
      },
      dropdownMenuEntries: dropdownEntries,
    );
  }
}